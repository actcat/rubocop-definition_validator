module RuboCop
  module Cop
    module Lint
      class Diff < Cop
        def on_send(node)
          name = node.method_name.to_s
          args = node.method_args

          msg = nil
          Rubocop::Diff::ChangeDetector.changed_methods.each do |m|
            old, new = m[:removed], m[:added]
            old_callable, _ = old.callable?(name, args)
            next unless old_callable

            new_callable, reason = new.callable?(name, args)
            next if new_callable

            msg = reason.respond_to?(:call) ? reason.(old, new) : reason
          end

          return unless msg
          add_offense(node, :expression, 'Its worng!')
        end
      end
    end
  end
end
