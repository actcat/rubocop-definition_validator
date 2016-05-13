require 'ripper'

class Rubocop::Diff::ChangeDetector
  def initialize(diff)
    parsed = GitDiffParser::Patches.parse(diff)
    @patches = parsed.map{|orig_patch| patch = Rubocop::Diff::Patch.new(orig_patch)}
  end

  def detect
    @patches
      .map{|patch| patch.changed_methods}
  end

  # @param [String] definition
  def signature(definition)
    code = "#{definition}; end"
    ast = Ripper.sexp(code)
    return nil unless ast

  end
end
