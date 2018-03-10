module Methods
  class Configuration
    # Defines if the curried args are prepended or appended to the
    # arguments received during the method call
    #
    # Valid values: :prepend, :append
    attr_accessor :curry_args_strategy

    def initialize
      @curry_args_strategy = :prepend
    end
  end
end
