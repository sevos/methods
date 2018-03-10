require "methods/version"
require "methods/configuration"
require 'binding_of_caller'
require "methods/methods_wrapper"
require "methods/instance_methods_wrapper"
require "methods/method_without_args"

module Methods
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

Object.include Methods::MethodWithoutArgs
