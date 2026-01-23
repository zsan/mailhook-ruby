# frozen_string_literal: true

module Mailhook
  # Configuration class for storing Mailhook API settings.
  #
  # @example Configure using block
  #   Mailhook.configure do |config|
  #     config.agent_id = "your_agent_id"
  #     config.api_key = "your_api_key"
  #   end
  #
  # @example Configure directly
  #   Mailhook.configuration.agent_id = "your_agent_id"
  #   Mailhook.configuration.api_key = "your_api_key"
  class Configuration
    # @return [String] The Agent ID for authentication
    attr_accessor :agent_id

    # @return [String] The API Key for authentication
    attr_accessor :api_key

    # @return [String] The base URL for the Mailhook API
    attr_accessor :base_url

    # @return [Integer] Request timeout in seconds
    attr_accessor :timeout

    # @return [Integer] Connection open timeout in seconds
    attr_accessor :open_timeout

    # @return [Integer] Maximum number of retries for failed requests
    attr_accessor :max_retries

    # @return [Array<Integer>] HTTP status codes that should trigger a retry
    attr_accessor :retry_statuses

    DEFAULT_BASE_URL = "https://app.mailhook.co/api/v1"
    DEFAULT_TIMEOUT = 30
    DEFAULT_OPEN_TIMEOUT = 10
    DEFAULT_MAX_RETRIES = 2
    DEFAULT_RETRY_STATUSES = [429, 500, 502, 503, 504].freeze

    def initialize
      @base_url = DEFAULT_BASE_URL
      @timeout = DEFAULT_TIMEOUT
      @open_timeout = DEFAULT_OPEN_TIMEOUT
      @max_retries = DEFAULT_MAX_RETRIES
      @retry_statuses = DEFAULT_RETRY_STATUSES.dup
    end

    # Reset configuration to defaults
    # @return [void]
    def reset!
      @agent_id = nil
      @api_key = nil
      @base_url = DEFAULT_BASE_URL
      @timeout = DEFAULT_TIMEOUT
      @open_timeout = DEFAULT_OPEN_TIMEOUT
      @max_retries = DEFAULT_MAX_RETRIES
      @retry_statuses = DEFAULT_RETRY_STATUSES.dup
    end

    # Check if credentials are configured
    # @return [Boolean] true if both agent_id and api_key are set
    def credentials?
      !agent_id.nil? && !agent_id.empty? && !api_key.nil? && !api_key.empty?
    end
  end
end
