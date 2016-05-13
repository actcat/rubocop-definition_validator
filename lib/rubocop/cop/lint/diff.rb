module RuboCop
  module Cop
    module Lint
      class Diff < Cop
        def on_send(node)
          require 'pry'
          binding.pry
        end
      end
    end
  end
end
