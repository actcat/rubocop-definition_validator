require 'spec_helper'

describe Rubocop::Diff::ChangeDetector do
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

  describe '.init' do
    subject{Rubocop::Diff::ChangeDetector.changed_methods}
    it 'should assign @changed_methods' do
      Rubocop::Diff::ChangeDetector.init(diff)
      is_asserted_by{ subject.size == 1 }
      is_asserted_by{ subject.first[:added].is_a? Rubocop::Diff::Method }
      is_asserted_by{ subject.first[:removed].is_a? Rubocop::Diff::Method }
    end
  end
end
