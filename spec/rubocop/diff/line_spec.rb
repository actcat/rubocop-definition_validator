require 'spec_helper'

describe Rubocop::Diff::Line do
  let(:content){'-  def foo'}
  let(:line){Rubocop::Diff::Line.new({
    content: content,
    number: 1,
    patch_position: 2,
  })}

  describe '#body' do
    it 'should return code body' do
      is_asserted_by{ line.body == '  def foo' }
    end
  end
end
