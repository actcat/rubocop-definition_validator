# Rubocop::DefinitionValidator

This tool detects omission of modification of callers when the name of a method, number of arguments, or the name of a keyword argument is modified.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-definition_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubocop-definition_validator

## Usage

```sh
$ git diff TARGET_COMMIT > ./.rubocop-definition_validator.diff
$ rubocop -r rubocop/definition_validator
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/actcat/rubocop-definition_validator.

