module RuboCop
  module Cop
    module Lint
      class Diff < Cop
        def on_send(node)
          name = node.method_name.to_s
          args = node.method_args

          method = Rubocop::Diff::ChangeDetector.changed_methods.find do |m|
            m[:removed].callable?(name, args) && !m[:added].callable?(name, args)
          end
          return unless method
          add_offense(node, :expression, 'Its worng!')
        end
      end
    end
  end
end
