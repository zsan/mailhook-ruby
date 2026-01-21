# frozen_string_literal: true

module Mailhook
  # Base error class for all Mailhook errors
  class Error < StandardError
    # @return [Faraday::Response, nil] The HTTP response that caused the error
    attr_reader :response

    # @return [Integer, nil] HTTP status code
    attr_reader :status

    # @return [Hash, nil] Parsed response body
    attr_reader :body

    def initialize(message = nil, response: nil)
      @response = response
      @status = response&.status
      @body = parse_body(response&.body)
      super(message || default_message)
    end

    private

    def parse_body(body)
      return nil if body.nil? || body.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      { "raw" => body }
    end

    def default_message
      body&.dig("error") || body&.dig("message") || "An error occurred"
    end
  end

  # Raised when API credentials are missing or invalid
  class AuthenticationError < Error
    def default_message
      "Invalid or missing API credentials"
    end
  end

  # Raised when the requested resource is not found (404)
  class NotFoundError < Error
    def default_message
      "The requested resource was not found"
    end
  end

  # Raised when rate limit is exceeded (429)
  class RateLimitError < Error
    # @return [Integer, nil] Number of seconds to wait before retrying
    attr_reader :retry_after

    def initialize(message = nil, response: nil)
      @retry_after = extract_retry_after(response)
      super
    end

    def default_message
      msg = "Rate limit exceeded"
      msg += ". Retry after #{retry_after} seconds" if retry_after
      msg
    end

    private

    def extract_retry_after(response)
      return nil unless response

      value = response.headers["retry-after"] || response.headers["Retry-After"]
      value&.to_i
    end
  end

  # Raised when the request is invalid (400)
  class BadRequestError < Error
    def default_message
      "The request was invalid"
    end
  end

  # Raised when access is forbidden (403)
  class ForbiddenError < Error
    def default_message
      "Access to this resource is forbidden"
    end
  end

  # Raised when there's a conflict (409)
  class ConflictError < Error
    def default_message
      "The request conflicts with the current state"
    end
  end

  # Raised when the entity is unprocessable (422)
  class UnprocessableEntityError < Error
    # @return [Hash, nil] Validation errors from the response
    attr_reader :errors

    def initialize(message = nil, response: nil)
      super
      @errors = body&.dig("errors")
    end

    def default_message
      "The request could not be processed"
    end
  end

  # Raised when there's a server error (5xx)
  class ServerError < Error
    def default_message
      "An internal server error occurred"
    end
  end

  # Raised when a connection error occurs
  class ConnectionError < Error
    def default_message
      "Failed to connect to the Mailhook API"
    end
  end

  # Raised when a request times out
  class TimeoutError < Error
    def default_message
      "The request timed out"
    end
  end

  # Raised when configuration is invalid
  class ConfigurationError < Error
    def default_message
      "Invalid configuration"
    end
  end
end
