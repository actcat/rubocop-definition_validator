require 'git_diff_parser'

require "rubocop/diff/version"
require 'rubocop/diff/inject'
require 'rubocop/diff/line'
require 'rubocop/diff/patch'
require 'rubocop/diff/change_detector'

RuboCop::Diff::Inject.defaults!

require 'rubocop/cop/lint/diff'
