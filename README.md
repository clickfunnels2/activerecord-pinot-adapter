# Pinot Adapter

Ruby on Rails Active Record database adapter for Apache Pinot, a client library for Pinot-compatible database servers.

Disclaimer: This is alpha stage software, please use with caution.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add activerecord-pinot-adapter

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install activerecord-pinot-adapter

This adapter uses the [pinot](https://rubygems.org/gems/pinot) gem, that is the Apache Pinot client, you can install an specific version of the client, but it's highly recommended to let this gem manage its own dependency.

## Usage

TODO: Write usage instructions here
First step is to configure the `config/database.yml`

```yaml
pinot:
  adapter: pinot
  host: host.to.your.broker.com
  port: 443
  controller_host: host.to.your.controller.com
  controller_port: 443
  protocol: https
```

Adapter also supports:

- `socks5_uri` in case you are using are using a jump host as your socks proxy. Please provide the full uri with protocol and port (eg. `socks5://127.0.0.1:8080`)
- `bearer_token` in case your broker/host need a bearer token to authenticate the requests
- `query_options` in case needs to specify pinot [query options](https://docs.pinot.apache.org/users/user-guide-query/query-options), it's a hash, and keys are on the _underscore_ format.

By design we avoided trying to guess the port and protocol based on any provided information, so port is always required, and protocol by default is `http` to make easier to test local, and then must be specified as `https` for production.

### Models

To start using on your application, it's recommended to create an abstract class, so it's only needed to specify the connection database in one place.

```ruby
class PinotRecord < ApplicationRecord
  self.abstract_class = true
  connects_to database: {writing: :pinot, reading: :pinot}
end
```

After abstract class, just use it on any class you want to use.

```ruby
class MyModel < PinotRecord
end
```

If you are incrementally migrating from one database to Pinot, or want to use both in parallel, prefix your models on a namespace, and use `self.table_name=` to specify the correct table name for the model.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activerecord-pinot-adapter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/activerecord-pinot-adapter/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Activerecord::Pinot::Adapter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/activerecord-pinot-adapter/blob/main/CODE_OF_CONDUCT.md).
