require 'git_diff_parser'

require "rubocop/diff/version"
require 'rubocop/diff/inject'
require 'rubocop/diff/line'
require 'rubocop/diff/patch'
require 'rubocop/diff/change_detector'

RuboCop::Rails::Inject.defaults!

# module Rubocop
#   module Diff
#     # Your code goes here...
#   end
# end
