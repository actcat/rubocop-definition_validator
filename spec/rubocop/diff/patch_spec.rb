require 'spec_helper'

describe Rubocop::Diff::Patch do
  let(:diff){
    <<-DIFF
diff --git a/foo.rb b/bar.rb
index 51aec3b..ae23ea2 100644
--- a/foo.rb
+++ b/bar.rb
@@ -1,5 +1,5 @@
 class A
-  def foo
+  def bar
     puts 'foo'
   end
 end
    DIFF
  }
  let(:patch){Rubocop::Diff::Patch.new(diff)}

  describe '#changed_lines' do
    subject{patch.changed_lines}

    it {is_expected.to be_a Array}

    it 'size eq 2' do
      is_asserted_by{ subject.size == 2 }
    end

    it 'first line is removed line' do
      is_asserted_by{ subject[0].content == "-  def foo\n" }
    end

    it 'second line is added line' do
      is_asserted_by{ subject[1].content == "+  def bar\n" }
    end
  end
end
