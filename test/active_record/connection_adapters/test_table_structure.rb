# frozen_string_literal: true

require "test_helper"

class ActiveRecord::ConnectionAdapters::PinotAdapter::TestTableStructure < Minitest::Test
  def setup
    @table_structure = ActiveRecord::ConnectionAdapters::PinotAdapter::TableStructure.from_schema(schema)
    @table_structure.sort_by! { |x| x["name"] }
  end

  def test_return_the_fields_correctly
    expected_fields = [
      {name: "author_id", type: "integer", pinot_type: "dimension"},
      {name: "comments", type: "integer", pinot_type: "metric"},
      {name: "created_at", type: "TIMESTAMP", pinot_type: "dateTime", metadata: {format: "1:MILLISECONDS:EPOCH", granularity: "1:MILLISECONDS"}},
      {name: "id", type: "integer", pinot_type: "dimension", pk: 1},
      {name: "slug", type: "varchar", pinot_type: "dimension"}
    ]
    expected_fields.map(&:deep_stringify_keys!)
    assert_equal expected_fields, @table_structure
    assert true
  end

  def schema
    payload = <<~SCHEMA
      {
        "schemaName": "posts",
        "dimensionFieldSpecs": [
          {
            "name": "id",
            "dataType": "INT"
          },
          {
            "name": "slug",
            "dataType": "STRING"
          },
          {
            "name": "author_id",
            "dataType": "INT"
          }
        ],
        "metricFieldSpecs": [
          {
            "name": "comments",
            "dataType": "INT"
          }
        ],
        "dateTimeFieldSpecs": [
          {
            "name": "created_at",
            "dataType": "TIMESTAMP",
            "format": "1:MILLISECONDS:EPOCH",
            "granularity": "1:MILLISECONDS"
          }
        ],
        "primaryKeyColumns": [
          "id"
        ]
      }
    SCHEMA
    JSON.parse(payload)
  end
end
