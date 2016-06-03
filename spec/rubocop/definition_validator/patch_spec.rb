require 'spec_helper'

describe Rubocop::DefinitionValidator::Patch do
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
  let(:patch){Rubocop::DefinitionValidator::Patch.new(GitDiffParser::Patch.new(diff))}

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

    it 'line number is 2' do
      is_asserted_by{ subject[0].number == subject[1].number }
      is_asserted_by{ subject[0].number == 2 }
    end
  end

  describe '#changed_methods' do
    subject{patch.changed_methods}

    it {is_expected.to be_a Array}
    it {is_expected.not_to be_empty}

    it 'should be Array of ChangedMethod' do
      subject.each do |s|
        is_asserted_by{ s.is_a? Rubocop::DefinitionValidator::ChangedMethod }
      end
    end

    it 'contain line number' do
      subject.each do |s|
        is_asserted_by{ s.line == 2 }
      end
    end
  end
end
