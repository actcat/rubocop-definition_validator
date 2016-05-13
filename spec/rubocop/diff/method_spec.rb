require 'spec_helper'

describe Rubocop::Diff::Method do
  describe '#callable?' do
    shared_examples 'should_be_callable' do
      it 'should be callable' do
        method = Rubocop::Diff::Method.new(code)
        is_asserted_by{ method.callable?(name, args) }
      end
    end

    shared_examples 'should_not_be_callable' do
      it 'should not be callable' do
        method = Rubocop::Diff::Method.new(code)
        is_asserted_by{ !method.callable?(name, args) }
      end
    end

    context 'simple, with paren' do
      let(:code){'def foo(a, b, c)'}
      let(:name){'foo'}
      let(:args){[1,2,3]}

      include_examples 'should_be_callable'
    end

    context 'simple, without paren' do
      let(:code){'def foo a, b, c'}
      let(:name){'foo'}
      let(:args){[1,2,3]}

      include_examples 'should_be_callable'
    end

    context 'simple, cant call' do
      let(:code){'def foo(a, b, c)'}
      let(:name){'bar'}
      let(:args){[1,2,3]}

      include_examples 'should_not_be_callable'
    end
  end
end
