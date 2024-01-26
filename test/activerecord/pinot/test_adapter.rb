# frozen_string_literal: true

require "test_helper"

class Metric < ActiveRecord::Base
end

class Post < ActiveRecord::Base
end

class Activerecord::Pinot::TestAdapter < Minitest::Test
  def setup
    host = ENV.fetch("PINOT_HOST", :localhost)
    controller_host = ENV.fetch("PINOT_CONTROLLER_HOST", :localhost)
    @client = Pinot::Client.new(host: host, controller_host: controller_host, port: 8099, controller_port: 9000)
    ActiveRecord::Base.establish_connection(adapter: "pinot", host: host, controller_host: controller_host, port: 8099, controller_port: 9000)
  end

  focus
  def test_focus
    expected_attributes = %w[id slug author_id comments created_at]
    assert_equal expected_attributes, Post.new.attributes.keys
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
