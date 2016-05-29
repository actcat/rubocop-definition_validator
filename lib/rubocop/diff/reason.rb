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
      n = expected - given
      -> (_old, new) {
        not_enough_arg_names = new.normal_params.dup.pop(n).map{|x| x[1]}
        "Not enough arguments. Did you forget the following arguments? #{not_enough_arguments.join(', ')}"
      }
    end
  end
end
