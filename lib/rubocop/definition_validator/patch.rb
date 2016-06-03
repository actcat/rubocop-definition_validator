#
# This class override `changed_lines` method.
# The original method retuns only added lines.
# However we want added and removed lines.
#
class Rubocop::DefinitionValidator::Patch < GitDiffParser::Patch
  ADDED_LINE   = -> (line) { line.start_with?('+') && line !~ /^\+\+\+/ }
  REMOVED_LINE = -> (line) { line.start_with?('-') && line !~ /^\-\-\-/ }

  def initialize(original_patch)
    @body = original_patch.body
    @file = original_patch.file
    @secure_hash = original_patch.secure_hash
  end

  # @return [Array<Line>] changed lines
  def changed_lines
    line_number = 0
    removed_line_offset = 0

    lines.each_with_index.inject([]) do |lines, (content, patch_position)|
      case content
      when RANGE_INFORMATION_LINE
        line_number = Regexp.last_match[:line_number].to_i
        removed_line_offset = 0
      when ADDED_LINE
        line = Rubocop::DefinitionValidator::Line.new(
          content: content,
          number: line_number,
          patch_position: patch_position
        )
        lines << line
        line_number += 1
        removed_line_offset = 0
      when REMOVED_LINE
        line = Rubocop::DefinitionValidator::Line.new(
          content: content,
          number: line_number + removed_line_offset,
          patch_position: patch_position
        )
        lines << line
        removed_line_offset +=1
      when NOT_REMOVED_LINE
        line_number += 1
        removed_line_offset = 0
      end

      lines
    end
  end

  def changed_method_codes
    lines = changed_lines
    lines
      .group_by{|l| l.number}
      .select{|_, v| v.size == 2}
      .select{|_, v| t = v.map(&:type); t.include?('-') && t.include?('+')}
      .select{|_, v| v.all?{|x| x.content =~ /def\s+\w+/}}
      .map{|line, v| s = v.sort_by(&:type); {added: s.first, removed: s.last, line: line}}
  end
end
