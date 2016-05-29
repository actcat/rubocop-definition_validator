require 'spec_helper'

describe Rubocop::Diff::Method do
  describe '#callable?' do
    shared_examples 'should_be_callable' do
      it 'should be callable' do
        method = Rubocop::Diff::Method.new(code)
        callable, reason = method.callable?(name, args)
        is_asserted_by{ callable == true }
        is_asserted_by{ reason == nil }
      end
    end

    shared_examples 'should_not_be_callable' do
      it 'should not be callable' do
        method = Rubocop::Diff::Method.new(code)
        callable, reason = method.callable?(name, args)
        is_asserted_by{ callable == false }
        is_asserted_by{ reason.is_a?(Proc) }
      end
    end

    context 'when no params' do
      let(:code){'def foo'}

      context 'when no args' do
        let(:name){'foo'}
        let(:args){[]}
        include_examples 'should_be_callable'
      end

      context 'when too many args' do
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

    context 'when has keyword params' do
      context 'when has keyword params with default value' do
        let(:code){'def foo(bar: 1, baz: 2)'}
        let(:name){'foo'}

        context 'when received no params' do
          let(:args){[]}
          include_examples 'should_be_callable'
        end

        context 'when received a pair' do
          let(:args){to_rubocop_ast('f bar: 3').method_args}
          include_examples 'should_be_callable'
        end

        context 'when received unexpected keyword' do
          let(:args){to_rubocop_ast('f hogehoge: 1').method_args}
          include_examples 'should_not_be_callable'
        end
      end

      context 'when has required keyword params' do
        let(:code){'def foo(bar:, baz: 1)'}
        let(:name){'foo'}

        context 'when received no params' do
          let(:args){[]}
          include_examples 'should_not_be_callable'
        end

        context 'when received required keyword' do
          let(:args){to_rubocop_ast('f bar: 1').method_args}
          include_examples 'should_be_callable'
        end

        context 'when received not required keyword only' do
          let(:args){to_rubocop_ast('f baz: 1').method_args}
          include_examples 'should_not_be_callable'
        end

        context 'when received unexpected keyword' do
          let(:args){to_rubocop_ast('f hogehoge: 1').method_args}
          include_examples 'should_not_be_callable'
        end
      end

      context 'when has rest keyword params' do
        let(:code){'def foo(bar: 1, **kwrest)'}
        let(:name){'foo'}

        context 'when received no params' do
          let(:args){[]}
          include_examples 'should_be_callable'
        end

        context 'when received unknown keyword' do
          let(:args){to_rubocop_ast('f hogehoge: 1').method_args}
          include_examples 'should_be_callable'
        end
      end
    end

    context 'when many parameter types' do
      let(:code){'def foo(a, b, c, m = 1, n = 1, *rest, x, y, z, k: 1, l:, **kwrest, &blk)'}
      let(:name){'foo'}

      context 'when minimum args' do
        let(:args){to_rubocop_ast('f a, b, c, x, y, z, l: 1').method_args}
        include_examples 'should_be_callable'
      end

      context 'when not enough args' do
        let(:args){to_rubocop_ast('f a, b, c, l: 1').method_args}
        include_examples 'should_not_be_callable'
      end

      context 'when many args' do
        let(:args){to_rubocop_ast('f a, b, c, d, e, f, g, h, i, j, k, l, l: 1').method_args}
        include_examples 'should_be_callable'
      end
    end
  end
end
