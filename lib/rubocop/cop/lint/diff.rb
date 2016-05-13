module RuboCop
  module Cop
    module Lint
      class Diff < Cop
        def on_send(node)
          name = node.method_name.to_s
          args = node.method_args

          Rubocop::Diff::ChangeDetector.changed_methods.each do |m|
            next unless m[:removed].callable?(name, args) && m[:added].callable?(name, args)
            # TODO: add_offence
            break
          end
        end
      end
    end
  end
end
