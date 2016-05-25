module Rubocop::Diff::ChangeDetector
  class << self
    attr_reader :changed_methods

    def init(diff_path)
      unless File.exist?(diff_path)
        @changed_methods = []
        return
      end

      diff = File.read(diff_path)
      parsed = GitDiffParser::Patches.parse(diff)
      patches = parsed.map{|orig_patch| patch = Rubocop::Diff::Patch.new(orig_patch)}
      # [
      #   {added: Method, removed: Method}
      # ]
      @changed_methods = patches
        .map{|patch| patch.changed_method_codes}
        .flatten
        .map{|code|
        code.map{|k, v|
          begin
            [k, Rubocop::Diff::Method.new(v.content)]
          rescue Rubocop::Diff::Method::InvalidAST
            nil
          end
        }.compact.to_h
      }
    end
  end
end

# XXX: 暫定的に rubocop-diff.diff からdiffを読む
Rubocop::Diff::ChangeDetector.init('./.rubocop-diff.diff')
