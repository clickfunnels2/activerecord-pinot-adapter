# frozen_string_literal: true

require "pinot"
require "active_record"
require_relative "../connection_adapters/pinot_adapter"

module ActiveRecord
  module Pinot
    module Adapter
      class Error < StandardError; end
      # Your code goes here...
    end
  end
end
