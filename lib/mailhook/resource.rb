# frozen_string_literal: true

module Mailhook
  # Base class for all API resources.
  # Provides common CRUD operations and connection handling.
  class Resource
    # @return [Connection] The HTTP connection object
    attr_reader :connection

    def initialize(connection)
      @connection = connection
    end

    protected

    # Make a GET request
    # @param path [String] Request path
    # @param params [Hash] Query parameters
    # @return [Response]
    def get(path, params = {})
      connection.get(path, params)
    end

    # Make a POST request
    # @param path [String] Request path
    # @param params [Hash] Request body
    # @return [Response]
    def post(path, params = {})
      connection.post(path, params)
    end

    # Make a PATCH request
    # @param path [String] Request path
    # @param params [Hash] Request body
    # @return [Response]
    def patch(path, params = {})
      connection.patch(path, params)
    end

    # Make a PUT request
    # @param path [String] Request path
    # @param params [Hash] Request body
    # @return [Response]
    def put(path, params = {})
      connection.put(path, params)
    end

    # Make a DELETE request
    # @param path [String] Request path
    # @param params [Hash] Query parameters
    # @return [Response]
    def delete(path, params = {})
      connection.delete(path, params)
    end

    # Build query string from parameters, filtering out nil values
    # @param params [Hash] Parameters
    # @return [Hash] Filtered parameters
    def clean_params(params)
      params.compact
    end
  end
end
