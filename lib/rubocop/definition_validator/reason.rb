module Rubocop::DefinitionValidator::Reason
  class << self
    # @return [Proc]
    def method_name
      -> (old, new) { "#{old.name} is undefined. Did you mean? #{new.name}" }
    end

    # @param [Integer] given given args size.
    # @param [Integer] expected expected args size.
    # @param [Symbol] kind normal_params or normal_params_after_rest
    # @return [Proc]
    def not_enough_arguments(given, expected, kind)
      n = expected - given
      -> (_old, new) {
        not_enough_arg_names = new.__send__(kind).dup.pop(n).map{|x| x[1]}
        "Not enough arguments. Did you forget the following arguments? #{not_enough_arg_names.join(', ')}"
      }
    end
  end
end
