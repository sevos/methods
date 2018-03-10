module Methods
  class MethodsWrapper < BasicObject
    def initialize(obj, configuration)
      @obj = obj
      @configuration = configuration
    end

    def method_missing(method, *args, **kwargs, &block)
      __raise_no_method_error(method) unless respond_to?(method)
      method = @obj.method(method)

      if args.empty? && kwargs.empty? && block.nil?
        method
      else
        ::Kernel.lambda do |*call_args, **call_kwargs, &call_block|
          merged_args = __methods_merge_args(args, call_args)
          merged_kwargs = kwargs.merge(**call_kwargs)
          merged_block = call_block || block
          if merged_kwargs.empty?
            method.call(*merged_args, &merged_block)
          else
            method.call(*merged_args, **merged_kwargs, &merged_block)
          end
        end
      end
    end

    def respond_to?(method)
      if ::Kernel.binding.of_caller(2).eval('self').object_id == @obj.object_id
        @obj.respond_to?(method) || @obj.private_methods.include?(method)
      else
        @obj.respond_to?(method)
      end
    end

    def respond_to_missing?(*args)
      true
    end

    private

    def __methods_merge_args(args, call_args)
      case @configuration.curry_args_strategy
      when :prepend then [*args, *call_args]
      when :append then [*call_args, *args]
      else
        warn "Invalid value for option curry_args_strategy = #{@configuration.curry_args_strategy.inspect}"
        warn "Falling back to :prepend"
        [*args, *call_args]
      end
    end

    def __raise_no_method_error(method)
      ::Kernel.raise ::NoMethodError, "undefined method '#{method}' for #{@obj.inspect}:#{@obj.class.name}"
    end
  end
end
