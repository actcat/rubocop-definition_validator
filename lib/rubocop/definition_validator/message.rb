class Rubocop::DefinitionValidator::Message
  # @param [ChangedMethod] method
  def initialize(method)
    @method = method
  end

  # @param [Symbol] reason
  def of(reason, *args)
    __send__(reason, *args) + suffix
  end


  private

  # @return [Proc]
  def method_name
    "#{@method.removed.name} is undefined. Did you mean? #{@method.added.name}"
  end

  # @param [Integer] given given args size.
  # @param [Integer] expected expected args size.
  # @return [Proc]
  def not_enough_norml_arguments(given, expected)
    n = expected - given
    not_enough_arg_names = @method.added.normal_params.dup.pop(n).map{|x| x[1]}
    "Not enough arguments. Did you forget the following arguments? [#{not_enough_arg_names.join(', ')}]"
  end

  # @param [Integer] given given args size.
  # @param [Integer] expected expected args size.
  # @return [Proc]
  def not_enough_normal_after_rest_arguments(given, expected)
    n = expected - given
    not_enough_arg_names = @method.added.normal_params_after_rest.dup.pop(n).map{|x| x[1]}
    "Not enough arguments. Did you forget the following arguments? [#{not_enough_arg_names.join(', ')}]"
  end

  def too_many_arguments
    'Too many arguments'
  end

  def kwparam_required
    "Keyword params is required."
  end

  # @param [String] got
  def kwparam_should_be_hash(got)
    "Keyword params should be a Hash. But got #{got}"
  end

  # @param [Array<String>] not_founds
  def kwparam_not_found(not_founds)
    "The following keyword parameters are required. But not received. [#{not_founds.join(', ')}]"
  end

  def unexpected_kwparam(unexpected)
    "The following keyword parameters are not expected. But received. [#{unexpected.join(', ')}]"
  end



  def suffix
    "\nThis method is defined at #{@method.file_name} L#{@method.line}"
  end
end
