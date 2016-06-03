# This class has added method, removed method, line number and file name.
class Rubocop::DefinitionValidator::ChangedMethod
  attr_reader :added, :removed, :line, :file_name

  def initialize(added_line, removed_line, lineno, fname)
    @added = Rubocop::DefinitionValidator::Method.new(added_line.body)
    @removed = Rubocop::DefinitionValidator::Method.new(added_line.body)
    @line = lineno
    @file_name = fname
  end
end
