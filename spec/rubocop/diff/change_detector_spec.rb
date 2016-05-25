require 'spec_helper'

describe Rubocop::Diff::ChangeDetector do
  let(:diff){
    <<-'DIFF'
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
    DIFF
  }

  describe '.init' do
    let(:diff_path) do
      f = Tempfile.create('rubocop-diff-test-')
      f.write(diff)
      f.flush
      f.path
    end

    after do
      File.delete(diff_path)
    end

    subject{Rubocop::Diff::ChangeDetector.changed_methods}
    it 'should assign @changed_methods' do
      Rubocop::Diff::ChangeDetector.init(diff_path)
      is_asserted_by{ subject.size == 1 }
      is_asserted_by{ subject.first[:added].is_a? Rubocop::Diff::Method }
      is_asserted_by{ subject.first[:removed].is_a? Rubocop::Diff::Method }
    end
  end
end
