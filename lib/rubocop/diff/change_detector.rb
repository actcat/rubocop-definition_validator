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
  #
  # Definition Example:
  #   def f(a, b, c, m = 1, n = 1, *rest, x, y, z, k: 1, **kwrest, &blk)
  #
  # AST Example:
  #   [:program,
  #    [[:def,
  #      [:@ident, "f", [1, 4]],
  #      [:paren,
  #       [:params,
  #        [[:@ident, "a", [1, 6]], [:@ident, "b", [1, 9]], [:@ident, "c", [1, 12]]],
  #        [[[:@ident, "m", [1, 15]], [:@int, "1", [1, 19]]], [[:@ident, "n", [1, 22]], [:@int, "1", [1, 26]]]],
  #        [:rest_param, [:@ident, "rest", [1, 30]]],
  #        [[:@ident, "x", [1, 36]], [:@ident, "y", [1, 39]], [:@ident, "z", [1, 42]]],
  #        [[[:@label, "k:", [1, 45]], [:@int, "1", [1, 48]]]],
  #        [:@ident, "kwrest", [1, 53]],
  #        [:blockarg, [:@ident, "blk", [1, 62]]]]],
  #      [:bodystmt, [[:void_stmt]], nil, nil, nil]]]]
  def signature(definition)
    code = "#{definition}; end"

    ast = Ripper.sexp(code)
    return nil unless ast

    begin
      params = ast[1][0][2]
    rescue NoMethodError => ex
      warn "Can't parse AST. \nAST: #{ast}\nError: #{ex}"
      return nil
    end

    if params[0] == :paren
      params = params[1]
    end

    # TODO: いい感じの構造にする
    [
      # デフォルト式のない引数(複数指定可)
      params[1],
      # デフォルト式のある引数(複数指定可)
      params[2],
      # * を伴う引数(1つだけ指定可)
      params[3],
      # デフォルト式のない引数(複数指定可)
      params[4],
      # キーワード引数(複数指定可)
      params[5],
      # ** を伴う引数(1つだけ指定可)
      params[6],
      # & を伴う引数(1つだけ指定可)
      params[7],
    ]
  end
end
