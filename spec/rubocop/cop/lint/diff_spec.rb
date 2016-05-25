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
  end
end
