require "spec_helper"

RSpec.describe Methods do
  module LocalMath
    module_function

    def add(a, b)
      a + b
    end

    def multiply(a, b:)
      a * b
    end
  end

  class Circle
    def initialize(pi = Math::PI)
      @pi = pi
    end

    def perimeter(r)
      method.calculate(:perimeter).call(r)
    end

    private

    def calculate(what, r)
      case what
      when :perimeter
        2 * @pi * r
      when :area
        @pi * r ** 2
      end
    end
  end

  it "has a version number" do
    expect(Methods::VERSION).not_to be nil
  end

  it "allows to pass methods to a block" do
    expect([4, 9, 16].map(&Math.method.sqrt)).to eq([2, 3, 4])
  end

  it "allows to curry elements" do
    expect([4, 9, 16].map(&LocalMath.method.add(2))).to eq([6, 11, 18])
    expect([4, 9, 16].map(&LocalMath.method.multiply(b: 3))).to eq([12, 27, 48])
  end

  it 'the carried keyword arguments can be overriden' do
    method = LocalMath.method.multiply(5, b: 3)
    expect(method.call).to eq(15)
    expect(method.call(b: 2)).to eq(10)
  end

  it 'allows to access local variables even when carrying' do
    expect(Circle.new.perimeter(3)).to be > 18
  end

  it 'does not allow to access private methods from outside' do
    expect { Circle.new.method.calculate }.to raise_error(NoMethodError)
  end
end
