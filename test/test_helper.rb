# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require_relative "../lib/activerecord/pinot/adapter"
require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require "minitest/autorun"
require "minitest/focus"
