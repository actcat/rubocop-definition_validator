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

    context 'when no params' do
      let(:code){'def foo'}

      context 'when no args' do
        let(:name){'foo'}
        let(:args){[]}
        include_examples 'should_be_callable'
      end

      context 'when one args' do
        let(:name){'foo'}
        let(:args){[1,2,3]}
        include_examples 'should_not_be_callable'
      end
    end

    context 'when normal param only' do
      let(:code){'def foo(a, b, c)'}

      context 'simple, with paren' do
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
        let(:name){'bar'}
        let(:args){[1,2,3]}
        include_examples 'should_not_be_callable'
      end

      context 'too many args, cant call' do
        let(:name){'foo'}
        let(:args){[1,2,3,4]}
        include_examples 'should_not_be_callable'
      end

      context 'not enough args, cant call' do
        let(:name){'foo'}
        let(:args){[1]}
        include_examples 'should_not_be_callable'
      end
    end

    context 'when has default params' do
      context 'when default param only' do
        let(:code){'def foo(a=1)'}
        let(:name){'foo'}

        context 'with valid arg' do
          let(:args){[2]}
          include_examples 'should_be_callable'
        end

        context 'with empty arg' do
          let(:args){[]}
          include_examples 'should_be_callable'
        end
      end

      context 'with normal param' do
        let(:code){'def foo(a, b=1)'}
        let(:name){'foo'}

        context 'with valid arg' do
          let(:args){[2]}
          include_examples 'should_be_callable'
        end

        context 'with valid arg' do
          let(:args){[2, 2]}
          include_examples 'should_be_callable'
        end

        context 'when args not enough' do
          let(:args){[]}
          include_examples 'should_not_be_callable'
        end

        context 'when too many args' do
          let(:args){[1,2,3]}
          include_examples 'should_not_be_callable'
        end
      end
    end

    context 'when has rest params' do
      context 'when rest params only' do
        let(:code){'def foo(*rest)'}
        let(:name){'foo'}
        let(:args){[*0..10]}
        include_examples 'should_be_callable'
      end

      context 'with normal params' do
        let(:code){'def foo(a, *rest)'}
        let(:name){'foo'}

        context 'when valid args' do
          let(:args){[1,2,3]}
          include_examples 'should_be_callable'
        end

        context 'when valid args' do
          let(:args){[1]}
          include_examples 'should_be_callable'
        end

        context 'when invalid args' do
          let(:args){[]}
          include_examples 'should_not_be_callable'
        end
      end
    end

    context 'when has keyword params'  do
      # TODO
    end
  end
end
