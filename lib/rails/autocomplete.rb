require 'json'
require 'redis'
require 'redis/connection/hiredis'

require 'rails/autocomplete/version'

module Rails
  module Autocomplete
    class << self
      SEPARATOR = "\x00".freeze

      def save_terms(collection, terms, data = nil)
        fail "Collection cannot be blank." if collection.nil? || collection.size == 0
        return false if terms.nil? || terms.size == 0

        add = ""
        add = SEPARATOR + JSON.dump(data) unless data.nil? || data.size == 0

        terms.each do |term|
          value = strip_term(term) + add
          redis.zadd(collection, 0, value)
        end

        true
      end

      def find_terms(collection, terms, limit = 10)
        fail "Collection cannot be blank." if collection.nil? || collection.size == 0
        return [] if terms.nil? || terms.size == 0

        found = []
        responses = []

        terms.uniq.each do |term|
          redis.pipelined do
            responses << redis.zrangebylex(collection, "[#{term}", "[#{term}\xff", limit: [0, limit])
          end
        end

        responses.each do |resp|
          found += resp.value.map { |v| parse_value(v) }
        end

        found.uniq.sort
      end

      def redis
        Thread.current[:redis] ||= Redis.new
      end

      def strip_term(term)
        term.gsub(SEPARATOR, '')
      end

      def parse_value(value)
        term, encoded_data = value.split(SEPARATOR, 2)
        data = JSON.parse(encoded_data) unless encoded_data.nil? || encoded_data == ''
        [term, data]
      end
    end
  end
end
