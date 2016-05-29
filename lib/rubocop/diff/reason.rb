module Rubocop::Diff::Reason
  class << self
    # @return [Proc]
    def method_name
      -> (old, new) { "Maybe #{old.name} is undefined. Did you mean? #{new.name}" }
    end

    # @param [Integer] given given args size.
    # @param [Integer] expected expected args size.
    # @return [Proc]
    def not_enough_arguments(given, expected)
      -> (_old, new) { "Not enough arguments. Given #{given}, expected #{expected}" }
    end

  end
end
