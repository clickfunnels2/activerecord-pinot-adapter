# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require_relative "../lib/activerecord/pinot/adapter"
require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

host = ENV.fetch("PINOT_HOST", :localhost)
controller_host = ENV.fetch("PINOT_CONTROLLER_HOST", :localhost)
ActiveRecord::Base.establish_connection(adapter: "pinot", host: host, controller_host: controller_host, port: 8099, controller_port: 9000)
CLIENT = Pinot::Client.new(host: host, controller_host: controller_host, port: 8099, controller_port: 9000)

unless ENV.fetch("KEEP_SCHEMA", false)
  puts "Rebuilding Schema..."

  puts "-" * 80
  puts "-- posts"
  puts "-" * 80
  puts "Deleting Segments..."
  puts CLIENT.delete_segments("posts")
  sleep 1
  puts "Deleting Table..."
  puts CLIENT.delete_table("posts")
  puts "Giving 5 seconds to Pinot process the deletion.."

  5.downto(1) do |n|
    puts "#{n}.."
    sleep 1
  end

  puts "Creating Schema..."
  puts CLIENT.create_schema(File.read("./test/fixtures/posts_schema.json"))

  puts "Creating Table..."
  puts CLIENT.create_table(File.read("./test/fixtures/posts_table.json"))

  puts "Ingesting Data..."
  file = File.new(File.expand_path("./test/fixtures/posts.json"))
  puts CLIENT.ingest_json(file, table: "posts_OFFLINE")

  puts "Giving 3 seconds to process the ingested data.."

  3.downto(1) do |n|
    puts "#{n}.."
    sleep 1
  end
end

require "minitest/autorun"
require "minitest/focus"
