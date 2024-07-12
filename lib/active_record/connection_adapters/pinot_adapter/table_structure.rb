module ActiveRecord
  module ConnectionAdapters
    class PinotAdapter < AbstractAdapter
      module TableStructure
        def self.from_schema(schema)
          fields = []
          schema["dimensionFieldSpecs"].each do |f|
            fields << {
              "name" => f["name"],
              "type" => f["dataType"],
              "pinot_type" => "dimension"
            }
          end
          schema["metricFieldSpecs"] ||= []
          schema["metricFieldSpecs"].each do |f|
            fields << {
              "name" => f["name"],
              "type" => f["dataType"],
              "pinot_type" => "metric"
            }
          end
          schema["dateTimeFieldSpecs"].each do |f|
            fields << {
              "name" => f.delete("name"),
              "type" => f.delete("dataType"),
              "pinot_type" => "dateTime",
              "metadata" => f
            }
          end
          # normalize values
          fields.each do |f|
            f["type"] = normalize_type(f["type"])
          end
          # set primary keys
          primary_key_columns = schema["primaryKeyColumns"] || []
          primary_key_columns.each do |pk|
            pk_fields = fields.select { |x| x["name"] == pk }
            pk_fields.each { |field| field["pk"] = 1 }
          end
          fields
        end

        def self.normalize_type(type)
          case type
          when "INT" then "integer"
          when "STRING" then "varchar"
          else
            type
          end
        end
      end
    end
  end
end
