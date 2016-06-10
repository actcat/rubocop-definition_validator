module Rubocop::DefinitionValidator::ChangeDetector
  class << self
    attr_reader :changed_methods

    def init(diff_path)
      unless File.exist?(diff_path)
        @changed_methods = []
        return
      end

      diff = File.read(diff_path)
      parsed = GitDiffParser::Patches.parse(diff)
      patches = parsed.map{|orig_patch| patch = Rubocop::DefinitionValidator::Patch.new(orig_patch)}
      # [
      #   {added: Method, removed: Method}
      # ]
      @changed_methods = patches
        .map{|patch| patch.changed_methods}
        .flatten
    end

    def changed_methods
      @changed_methods || init('./.rubocop-definition_validator.diff')
    end
  end
end
