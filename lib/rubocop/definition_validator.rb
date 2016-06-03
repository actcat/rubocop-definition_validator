require 'git_diff_parser'

require 'rubocop'
require "rubocop/definition_validator/version"
require 'rubocop/definition_validator/inject'

RuboCop::DefinitionValidator::Inject.defaults!


require 'rubocop/definition_validator/line'
require 'rubocop/definition_validator/patch'
require 'rubocop/definition_validator/message'
require 'rubocop/definition_validator/changed_method'
require 'rubocop/definition_validator/method'
require 'rubocop/definition_validator/change_detector'

require 'rubocop/cop/lint/definition_validator'
