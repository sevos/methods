# Methods

This gem aims at making referencing methods in the Ruby language easier. It is greatly inspired by [this issue on the Ruby bug tracker](https://bugs.ruby-lang.org/issues/13581).

It allows you to grab a reference to a method by simply calling `method` on an object and calling the method you want on the result

```
irb(main):006:0> Math.method.sqrt
=> #<Method: Math.sqrt>
```

It allows parameters currying and respects method's visibility.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'methods'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install methods

## Usage

### Getting a reference

```
irb(main):006:0> Math.method.sqrt
=> #<Method: Math.sqrt>
```

### Passing a reference to an enumerator method

```
[4, 9, 16].map(&Math.method.sqrt).map(&:to_i).each(&method.puts)
2
3
4
=> [2, 3, 4]
```

### Argument currying

Yiu can curry any number of arguments in front of the argument list

```
[4, 9].map(&Math.method.sqrt).map(&:to_i).each(&method.puts("foo", "bar"))
foo
bar
2
foo
bar
3
=> [2, 3]
```

Also, currying keyword arguments works

```
irb(main):011:0> def adder(a, b, c:)
irb(main):012:1> a + b + c
irb(main):013:1> end
=> :adder
irb(main):014:0> [1,2,3].map(&method.adder(1, c: 5))
=> [7, 8, 9]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sevos/methods. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Acknowledgments

Many thanks to [Beni Cherniavsky-Paskin](https://github.com/cben) for the inspiration of the syntax!

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

