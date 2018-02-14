module Methods
  module MethodWithoutArgs
    def method(*args)
      if args.empty?
        Methods::MethodsWrapper.new(self)
      else
        super
      end
    end
  end
end
