class Rubocop::Diff::ChangeDetector
  def initialize(diff)
    parsed = GitDiffParser::Patches.parse(diff)
    parsed
      .map{|orig_patch| patch = Rubocop::Diff::Patch.new(orig_patch)}
      .select{}
  end
end
