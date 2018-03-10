require "spec_helper"

RSpec.describe Methods do
  def override_config_value(option, temporary_value)
    @old_config ||= {}
    @old_config[option] = Methods.configuration.public_send(option)
    Methods.configuration.public_send("#{option}=", temporary_value)
    yield
  ensure
    Methods.configuration.public_send("#{option}=", @old_config[option])
  end

  module LocalMath
    module_function

    def add(a, b)
      a + b
    end

    def subtract(a, b)
      a - b
    end

    def multiply(a, b:)
      a * b
    end

    def multiply_block(a, b)
      a * yield(b)
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

  describe 'args currying' do
    describe 'configuration -> curry_args_strategy' do
      context 'append' do
        around(:example) do |example|
          override_config_value(:curry_args_strategy, :append) do
            example.run
          end
        end

        it "places the curried args after the call args" do
          expect([4, 9, 16].map(&LocalMath.method.subtract(2))).to eq([2, 7, 14])
        end
      end

      context 'prepend' do
        around(:example) do |example|
          override_config_value(:curry_args_strategy, :prepend) do
            example.run
          end
        end

        it "places the curried args before the call args" do
          expect([4, 9, 16].map(&LocalMath.method.subtract(2))).to eq([-2, -7, -14])
        end
      end
    end
  end

  describe 'kwargs currying' do
    it 'allows to curry keyword arguments' do
      expect([4, 9, 16].map(&LocalMath.method.multiply(b: 3))).to eq([12, 27, 48])
    end

    it 'the carried keyword arguments can be overriden' do
      method = LocalMath.method.multiply(5, b: 3)
      expect(method.call).to eq(15)
      expect(method.call(b: 2)).to eq(10)
    end
  end

  it 'allows to access local variables even when currying' do
    expect(Circle.new.perimeter(3)).to be > 18
  end

  it 'does not allow to access private methods from outside' do
    expect { Circle.new.method.calculate }.to raise_error(NoMethodError)
  end

  it 'allows block currying and block overrides' do
    m = LocalMath.method.multiply_block(2) { |x| x + 1 }
    expect(m.call(4)).to eq(10)
    expect(m.call(4) { |x| x - 1 }).to eq(6)
  end

  it 'allows to get instance method' do
    unbound_method = Circle.instance_method.perimeter
    expect(
      unbound_method.bind(Circle.new).call(3)
    ).to be > 18
  end
end
