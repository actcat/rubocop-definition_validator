class Rubocop::Diff::Line < GitDiffParser::Line
  attr_reader :content

  # trim `+` or `-` prefix
  def body
    content[1..-1]
  end
end
