require 'spec_helper'

describe RuboCop::Cop::Lint::Diff do
  subject(:cop){described_class.new}

  before do
    f = Tempfile.create('rubocop-diff-test-')
    f.write(diff)
    f.flush
    Rubocop::Diff::ChangeDetector.init(f.path)
    File.delete(f.path)
  end

  context 'when does not have any changes' do
    let(:diff){''}

    it 'accepts' do
      inspect_source(cop, 'foo()')
      expect(cop.offenses).to be_empty
    end

    it 'accepts empty code' do
      inspect_source(cop, '')
      expect(cop.offenses).to be_empty
    end
  end

  context 'when method name was changed' do
    let(:diff){<<-'CODE'}
diff --git a/test.rb b/test2.rb
index df650ee..7180d75 100644
--- a/test.rb
+++ b/test2.rb
@@ -1,5 +1,5 @@
-def hello(name)
-  puts "hello #{name}!"
+def hi(name)
+  puts "hi #{name}!"
 end
 
 hello('pocke')
    CODE

    it 'accepts use `hi` method' do
      inspect_source(cop, 'hi(name)')
      expect(cop.offenses).to be_empty
    end

    it 'registers an offense for `hello` method' do
      inspect_source(cop, 'hello(name)')
      expect(cop.offenses.size).to eq 1
    end

    it 'accpets use unrelated method name' do
      inspect_source(cop, 'poyopoyo(name)')
      expect(cop.offenses).to be_empty
    end
  end

  context 'when method args ware changed' do
    let(:diff){<<-'CODE'}
diff --git a/test.rb b/test2.rb
index 6ca6c0f..6c5790d 100644
--- a/test.rb
+++ b/test2.rb
@@ -1,5 +1,5 @@
-def hello(name)
-  puts "hello #{name}"
+def hello(name, message)
+  puts "hello #{name} #{message}"
 end
 
-hello('pocke')
+hello('pocke', 'konnitiwa')
    CODE

    it 'accpets call with 2 args' do
      inspect_source(cop, 'hello("pocke", "meow")')
      expect(cop.offenses).to be_empty
    end

    it 'accpets call with 1 args' do
      inspect_source(cop, 'hello("pocke")')
      expect(cop.offenses.size).to eq 1
    end
  end

  context 'when keyword params became required.' do
    let(:diff){<<-'CODE'}
diff --git a/test.rb b/test2.rb
index 5ccf77e..0aba155 100644
--- a/test.rb
+++ b/test2.rb
@@ -1,3 +1,3 @@
-def foo(a: 1)
+def foo(a:)
   puts a
 end
    CODE

    it 'registers an offence for calling foo without any args' do
      inspect_source(cop, 'foo')
      expect(cop.offenses.size).to eq 1
    end

    it 'accepts call with keyword args' do
      inspect_source(cop, 'foo(a: 1)')
      expect(cop.offenses).to be_empty
    end
  end
end
