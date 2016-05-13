module RuboCop
  module Cop
    module Lint
      class Diff < Cop
        def on_send(node)
          name = node.method_name.to_s
          args = node.method_args

          # TODO: こんなイメージなので、清書する
          if old_method.callable?(name, args) && !new_method.callable?(name, args)
            add_offence
          end
        end
      end
    end
  end
end
