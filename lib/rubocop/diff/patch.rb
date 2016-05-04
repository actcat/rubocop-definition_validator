#
# This class override `changed_lines` method.
# The original method retuns only added lines.
# However we want added and removed lines.
#
class Rubocop::Diff::Patch < GitDiffParser::Patch
  ADDED_LINE   = -> (line) { line.start_with?('+') && line !~ /^\+\+\+/ }
  REMOVED_LINE = -> (line) { line.start_with?('-') && line !~ /^\-\-\-/ }

  # @return [Array<Line>] changed lines
  def changed_lines
    line_number = 0

    lines.each_with_index.inject([]) do |lines, (content, patch_position)|
      case content
      when RANGE_INFORMATION_LINE
        line_number = Regexp.last_match[:line_number].to_i
      when ADDED_LINE
        line = Rubocop::Diff::Line.new(
          content: content,
          number: line_number,
          patch_position: patch_position
        )
        lines << line
        line_number += 1
      when REMOVED_LINE
        line = Rubocop::Diff::Line.new(
          content: content,
          number: line_number,
          patch_position: patch_position
        )
        lines << line
      when NOT_REMOVED_LINE
        line_number += 1
      end

      lines
    end
  end
end
