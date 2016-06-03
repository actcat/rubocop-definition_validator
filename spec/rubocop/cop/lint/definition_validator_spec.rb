require 'spec_helper'

describe RuboCop::Cop::Lint::DefinitionValidator, :config do
  subject(:cop){described_class.new(config)}
  let(:cop_config) { { 'Min' => 6 } }

  before do
    f = Tempfile.create('rubocop-definition_validator-test-')
    f.write(diff)
    f.flush
    Rubocop::DefinitionValidator::ChangeDetector.init(f.path)
    File.delete(f.path)
  end

  context 'when does not have any changes' do
    let(:diff){''}

    it 'accepts' do
      inspect_source(cop, 'foobarbaz()')
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
-def hellohello(name)
-  puts "hellohello #{name}!"
+def hi(name)
+  puts "hi #{name}!"
 end
 
 hellohello('pocke')
    CODE

    it 'accepts use `hi` method' do
      inspect_source(cop, 'hi(name)')
      expect(cop.offenses).to be_empty
    end

    it 'registers an offense for `hellohello` method' do
      inspect_source(cop, 'hellohello(name)')
      expect(cop.offenses.size).to eq 1
      expect(cop.offenses.first.message).to eq "hellohello is undefined. Did you mean? hi\nThis method is defined at test.rb L1"
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
-def hellohello(name)
-  puts "hellohello #{name}"
+def hellohello(name, message)
+  puts "hellohello #{name} #{message}"
 end
 
-hellohello('pocke')
+hellohello('pocke', 'konnitiwa')
    CODE

    it 'accpets call with 2 args' do
      inspect_source(cop, 'hellohello("pocke", "meow")')
      expect(cop.offenses).to be_empty
    end

    it 'accpets call with 1 args' do
      inspect_source(cop, 'hellohello("pocke")')
      expect(cop.offenses.size).to eq 1
      expect(cop.offenses.first.message).to eq 'Not enough arguments. Did you forget the following arguments? [message]\nThis method is defined at test.rb L1'
    end
  end

  context 'when keyword params became required.' do
    let(:diff){<<-'CODE'}
diff --git a/test.rb b/test2.rb
index 5ccf77e..0aba155 100644
--- a/test.rb
+++ b/test2.rb
@@ -1,3 +1,3 @@
-def foobarbaz(a: 1)
+def foobarbaz(a:)
   puts a
 end
    CODE

    it 'registers an offence for calling foobarbaz without any args' do
      inspect_source(cop, 'foobarbaz')
      expect(cop.offenses.size).to eq 1
      expect(cop.offenses.first.message).to eq 'Keyword params is required.\nThis method is defined at test.rb L1'
    end

    it 'accepts call with keyword args' do
      inspect_source(cop, 'foobarbaz(a: 1)')
      expect(cop.offenses).to be_empty
    end
  end
end
