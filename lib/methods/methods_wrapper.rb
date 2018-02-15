module Methods
  class MethodsWrapper < BasicObject
    def initialize(obj)
      @obj = obj
    end

    def method_missing(method, *args, **kwargs)
      __raise_no_method_error(method) unless respond_to?(method)
      method = @obj.method(method)

      if args.empty? && kwargs.empty?
        method
      else
        ::Kernel.lambda do |*call_args, **call_kwargs|
          merged_kwargs = kwargs.merge(**call_kwargs)
          if merged_kwargs.empty?
            method.call(*args, *call_args)
          else
            method.call(*args, *call_args, **merged_kwargs)
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

    def __raise_no_method_error(method)
      ::Kernel.raise ::NoMethodError, "undefined method '#{method}' for #{@obj.inspect}:#{@obj.class.name}"
    end
  end
end
