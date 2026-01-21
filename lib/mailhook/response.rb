# frozen_string_literal: true

module Mailhook
  # Response wrapper providing hash-like access to API responses.
  #
  # @example Accessing response data
  #   response = client.email_addresses.retrieve(123)
  #   response["id"]        # => 123
  #   response["address"]   # => "test@example.tail.me"
  #   response.data         # => { "id" => 123, "address" => "..." }
  #
  # @example List responses with pagination
  #   response = client.inbound_emails.list
  #   response.data         # => [{ "id" => 1, ... }, { "id" => 2, ... }]
  #   response.each { |email| puts email["subject"] }
  class Response
    include Enumerable

    # @return [Hash, Array] The parsed response data
    attr_reader :data

    # @return [Integer] HTTP status code
    attr_reader :status

    # @return [Hash] HTTP response headers
    attr_reader :headers

    # @return [Hash, nil] Pagination metadata if present
    attr_reader :meta

    def initialize(data:, status:, headers:)
      @status = status
      @headers = headers
      @data = extract_data(data)
      @meta = extract_meta(data)
    end

    # Access response data by key (hash-like access)
    # @param key [String, Symbol] The key to access
    # @return [Object] The value at the given key
    def [](key)
      return nil unless data.is_a?(Hash)

      data[key.to_s] || data[key.to_sym]
    end

    # Iterate over response data (for list responses)
    # @yield [Hash] Each item in the response
    def each(&block)
      return enum_for(:each) unless block_given?

      if data.is_a?(Array)
        data.each(&block)
      else
        yield data
      end
    end

    # Check if response is successful
    # @return [Boolean]
    def success?
      status >= 200 && status < 300
    end

    # Get all keys from the response data
    # @return [Array<String>]
    def keys
      return [] unless data.is_a?(Hash)

      data.keys
    end

    # Convert response to hash
    # @return [Hash]
    def to_h
      return data if data.is_a?(Hash)

      { "data" => data, "meta" => meta }.compact
    end

    # Convert response to JSON string
    # @return [String]
    def to_json(*args)
      to_h.to_json(*args)
    end

    # Check if a key exists in the response
    # @param key [String, Symbol] The key to check
    # @return [Boolean]
    def key?(key)
      return false unless data.is_a?(Hash)

      data.key?(key.to_s) || data.key?(key.to_sym)
    end

    # Get the first item (for list responses)
    # @return [Hash, nil]
    def first
      data.is_a?(Array) ? data.first : data
    end

    # Get the last item (for list responses)
    # @return [Hash, nil]
    def last
      data.is_a?(Array) ? data.last : data
    end

    # Get the count of items
    # @return [Integer]
    def count
      data.is_a?(Array) ? data.count : 1
    end

    alias size count
    alias length count

    # Check if response is empty
    # @return [Boolean]
    def empty?
      return data.empty? if data.respond_to?(:empty?)

      data.nil?
    end

    private

    def extract_data(parsed)
      return parsed unless parsed.is_a?(Hash)

      parsed["data"] || parsed
    end

    def extract_meta(parsed)
      return nil unless parsed.is_a?(Hash)

      parsed["meta"]
    end
  end
end
