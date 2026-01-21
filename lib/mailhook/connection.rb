# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "json"

module Mailhook
  # Handles HTTP connection setup and request execution using Faraday.
  class Connection
    # @return [Configuration] The configuration object
    attr_reader :config

    def initialize(config)
      @config = config
    end

    # Execute an HTTP request
    # @param method [Symbol] HTTP method (:get, :post, :patch, :delete)
    # @param path [String] Request path
    # @param params [Hash] Query parameters or request body
    # @return [Response] Wrapped response object
    def request(method, path, params = {})
      response = connection.public_send(method, path) do |req|
        case method
        when :get, :delete
          req.params = params unless params.empty?
        when :post, :patch, :put
          req.body = params.to_json unless params.empty?
        end
      end

      handle_response(response)
    rescue Faraday::ConnectionFailed => e
      raise ConnectionError, e.message
    rescue Faraday::TimeoutError => e
      raise TimeoutError, e.message
    end

    # Make a GET request
    # @param path [String] Request path
    # @param params [Hash] Query parameters
    # @return [Response]
    def get(path, params = {})
      request(:get, path, params)
    end

    # Make a POST request
    # @param path [String] Request path
    # @param params [Hash] Request body
    # @return [Response]
    def post(path, params = {})
      request(:post, path, params)
    end

    # Make a PATCH request
    # @param path [String] Request path
    # @param params [Hash] Request body
    # @return [Response]
    def patch(path, params = {})
      request(:patch, path, params)
    end

    # Make a PUT request
    # @param path [String] Request path
    # @param params [Hash] Request body
    # @return [Response]
    def put(path, params = {})
      request(:put, path, params)
    end

    # Make a DELETE request
    # @param path [String] Request path
    # @param params [Hash] Query parameters
    # @return [Response]
    def delete(path, params = {})
      request(:delete, path, params)
    end

    private

    def connection
      @connection ||= Faraday.new(url: config.base_url) do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.headers["Accept"] = "application/json"
        conn.headers["User-Agent"] = "mailhook-ruby/#{Mailhook::VERSION}"

        # Add authentication headers if credentials are present
        if config.credentials?
          conn.headers["X-Agent-ID"] = config.agent_id
          conn.headers["X-API-Key"] = config.api_key
        end

        # Configure retry middleware
        conn.request :retry,
                     max: config.max_retries,
                     interval: 0.5,
                     interval_randomness: 0.5,
                     backoff_factor: 2,
                     retry_statuses: config.retry_statuses

        # Configure timeouts
        conn.options.timeout = config.timeout
        conn.options.open_timeout = config.open_timeout

        conn.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      check_for_errors(response)

      parsed = parse_body(response.body)
      Response.new(
        data: parsed,
        status: response.status,
        headers: response.headers.to_h
      )
    end

    def parse_body(body)
      return {} if body.nil? || body.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      { "raw" => body }
    end

    def check_for_errors(response)
      case response.status
      when 200..299
        nil
      when 400
        raise BadRequestError.new(response: response)
      when 401
        raise AuthenticationError.new(response: response)
      when 403
        raise ForbiddenError.new(response: response)
      when 404
        raise NotFoundError.new(response: response)
      when 409
        raise ConflictError.new(response: response)
      when 422
        raise UnprocessableEntityError.new(response: response)
      when 429
        raise RateLimitError.new(response: response)
      when 500..599
        raise ServerError.new(response: response)
      else
        raise Error.new("Unexpected response status: #{response.status}", response: response)
      end
    end
  end
end
