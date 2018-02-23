module Methods
  class InstanceMethodsWrapper < BasicObject
    def initialize(obj)
      @obj = obj
    end

    def method_missing(method)
      @obj.instance_method(method)
    end

    def respond_to_missing?(*args)
      true
    end
  end
end
