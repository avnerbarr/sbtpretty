# Sbtpretty

Small tool to make the output of `sbt test` a bit more bearable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sbtpretty'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sbtpretty

## Usage

After you have installed it , from a `sbt` directory you are running tests in do:

`sbt test 2>&1 sbtpretty`

Notice that we are piping the STDERR to the pretty-fier as well so that we can make a nice looking output


## Appearance

Your logs should start to look nice like this:

```
sbt test 2>&1 | sbtpretty
▸ PaginationSerializationSpec:
▸ parse empty requests
▸ parse with null values
▸ parse with sort request
....
....
....
....
▸ Tests: succeeded 8, failed 0, canceled 0, ignored 0, pending 0
✅   All tests passed.
 Passed: Total 8, Failed 0, Errors 0, Passed 8
....
✅   All tests passed.
 Passed: Total 73, Failed 0, Errors 0, Passed 73
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sbtpretty. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
