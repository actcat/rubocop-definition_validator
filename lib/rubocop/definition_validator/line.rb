class Rubocop::DefinitionValidator::Line < GitDiffParser::Line
  attr_reader :content

  # trim `+` or `-` prefix
  def body
    content[1..-1]
  end

  # @return [String] + or -
  def type
    content[0]
  end
end
