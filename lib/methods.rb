require "methods/version"
require 'binding_of_caller'
require "methods/methods_wrapper"
require "methods/method_without_args"

module Methods
end

Object.include Methods::MethodWithoutArgs
