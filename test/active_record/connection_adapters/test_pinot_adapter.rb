# frozen_string_literal: true

require "test_helper"
require "active_record/database_configurations"

class Metric < ActiveRecord::Base
end

class Post < ActiveRecord::Base
end

class Activerecord::Pinot::TestAdapter < Minitest::Test
  def setup
    @client = Pinot::Client.new(host: :localhost, port: 8099, controller_port: 9000)
    ActiveRecord::Base.establish_connection(adapter: "pinot", host: :localhost, port: 8099, controller_port: 9000)
  end

  focus
  def test_setup_on_test
    puts @client.delete_segments("posts")
    sleep 1
    puts @client.delete_table("posts")
    5.downto(1) do |n|
      puts "#{n}.."
      sleep 1
    end
    puts "create schema"
    puts @client.create_schema(File.read("./test/fixtures/posts_schema.json"))
    puts "create table"
    puts @client.create_table(File.read("./test/fixtures/posts_table.json"))
    puts "ingest json"
    file = File.new(File.expand_path("./test/fixtures/posts.json"))
    puts @client.ingest_json(file, table: "posts_OFFLINE")
    sleep 1
    assert_equal 3, Post.count
  end

  def test_focus
    puts Post.columns_hash
    puts Metric.new.attributes
  end

  def test_that_it_has_a_version_number
    refute_nil ::Activerecord::Pinot::Adapter::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_ok
    puts @client.schema("metrics")
    puts @client.schema("posts")

    # rows_total = pinot.execute("select count(*) from metrics;").rows.first.first
    # rows = pinot.execute("select * from metrics limit 3;").rows
    #
    # table = Terminal::Table.new title: "Metrics Table", headings: ["Tracked At", "Type ID", "Value"], rows: rows
    # table.add_separator
    # table.add_row ["Total", "", rows_total]
    # puts table

    puts "We can generate a SQL from a Pinot model"
    puts Metric.where(tracked_at: 1.year.ago..Time.now).to_sql

    3.times { puts "" }

    puts "Now let's get some records and iterate over"
    Metric.limit(5).each_with_index do |m, ix|
      puts "-----  Record #{ix + 1} ------"
      puts "Tracked At: #{m.tracked_at} with value #{m.value} (#{m.type_id})"
    end

    3.times { puts "" }

    puts "Now with some filters"
    puts Metric.limit(3).where(tracked_at: DateTime.parse("2023-06-01 00:00:00")..Time.now).to_sql
    Metric.limit(3).where(tracked_at: DateTime.parse("2023-06-01 00:00:00")..Time.now).each_with_index do |m, ix|
      puts "-----  Record #{ix + 1} ------"
      puts "Tracked At: #{m.tracked_at} with value #{m.value} (#{m.type_id})"
    end
  end

  def test_set_attributes_correctly
    puts ">" * 80
    Metric.limit(3).each_with_index do |m, ix|
      puts m.inspect
    end
    puts "<" * 80
  end
end
