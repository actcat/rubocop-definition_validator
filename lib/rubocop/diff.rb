require 'git_diff_parser'

require 'rubocop'
require "rubocop/diff/version"
require 'rubocop/diff/inject'

RuboCop::Diff::Inject.defaults!


require 'rubocop/diff/line'
require 'rubocop/diff/patch'
require 'rubocop/diff/reason'
require 'rubocop/diff/method'
require 'rubocop/diff/change_detector'

require 'rubocop/cop/lint/diff'
