# frozen_string_literal: true

module Mailhook
  # Main client for interacting with the Mailhook API.
  #
  # @example Using global configuration
  #   Mailhook.configure do |config|
  #     config.agent_id = "your_agent_id"
  #     config.api_key = "your_api_key"
  #   end
  #   client = Mailhook.client
  #
  # @example Using instance configuration
  #   client = Mailhook::Client.new(
  #     agent_id: "your_agent_id",
  #     api_key: "your_api_key"
  #   )
  class Client
    # @return [Configuration] The client configuration
    attr_reader :config

    # @return [Connection] The HTTP connection
    attr_reader :connection

    # Initialize a new client
    # @param agent_id [String, nil] Agent ID for authentication
    # @param api_key [String, nil] API key for authentication
    # @param base_url [String, nil] Base URL for the API
    # @param timeout [Integer, nil] Request timeout in seconds
    # @param open_timeout [Integer, nil] Connection timeout in seconds
    # @param max_retries [Integer, nil] Maximum retry attempts
    def initialize(agent_id: nil, api_key: nil, base_url: nil, timeout: nil, open_timeout: nil, max_retries: nil)
      @config = build_config(
        agent_id: agent_id,
        api_key: api_key,
        base_url: base_url,
        timeout: timeout,
        open_timeout: open_timeout,
        max_retries: max_retries
      )
      @connection = Connection.new(@config)
    end

    # Access the Agents resource
    # @return [Resources::Agents]
    def agents
      @agents ||= Resources::Agents.new(connection)
    end

    # Access the Domains resource
    # @return [Resources::Domains]
    def domains
      @domains ||= Resources::Domains.new(connection)
    end

    # Access the EmailAddresses resource
    # @return [Resources::EmailAddresses]
    def email_addresses
      @email_addresses ||= Resources::EmailAddresses.new(connection)
    end

    # Access the InboundEmails resource
    # @return [Resources::InboundEmails]
    def inbound_emails
      @inbound_emails ||= Resources::InboundEmails.new(connection)
    end

    # Access the Webhooks resource
    # @return [Resources::Webhooks]
    def webhooks
      @webhooks ||= Resources::Webhooks.new(connection)
    end

    # Access the OutboundEmails resource
    # @return [Resources::OutboundEmails]
    def outbound_emails
      @outbound_emails ||= Resources::OutboundEmails.new(connection)
    end

    private

    def build_config(agent_id:, api_key:, base_url:, timeout:, open_timeout:, max_retries:)
      config = Configuration.new

      # Use provided values or fall back to global configuration
      config.agent_id = agent_id || Mailhook.configuration.agent_id
      config.api_key = api_key || Mailhook.configuration.api_key
      config.base_url = base_url || Mailhook.configuration.base_url
      config.timeout = timeout || Mailhook.configuration.timeout
      config.open_timeout = open_timeout || Mailhook.configuration.open_timeout
      config.max_retries = max_retries || Mailhook.configuration.max_retries

      config
    end
  end
end
