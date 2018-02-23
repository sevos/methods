module Methods
  module MethodWithoutArgs
    module ClassMethods
      def instance_method(*args)
        if args.empty?
          Methods::InstanceMethodsWrapper.new(self)
        else
          super
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def method(*args)
      if args.empty?
        Methods::MethodsWrapper.new(self)
      else
        super
      end
    end
  end
end
