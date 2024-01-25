# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in activerecord-pinot-adapter.gemspec
gemspec

case ENV["PINOT_SOURCE"]
when "local"
  gem "pinot", path: "../pinot"
when "github"
  gem "pinot", github: "fernandes/pinot"
else
  gem "pinot"
end

gem "rake", "~> 13.0"

gem "minitest", "~> 5.0"

gem "standard", "~> 1.3"
