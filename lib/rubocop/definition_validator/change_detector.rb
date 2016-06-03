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
        .map{|patch| patch.changed_method_codes}
        .flatten
        .map{|code|
        code.map{|k, v|
          next [k, v] if k == :line
          begin
            [k, Rubocop::DefinitionValidator::Method.new(v.body)]
          rescue Rubocop::DefinitionValidator::Method::InvalidAST
            nil
          end
        }.compact.to_h
      }
    end
  end
end

# XXX: 暫定的に .rubocop-definition_validator.diff からdiffを読む
Rubocop::DefinitionValidator::ChangeDetector.init('./.rubocop-definition_validator.diff')
