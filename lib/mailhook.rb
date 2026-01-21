# frozen_string_literal: true

require_relative "mailhook/version"
require_relative "mailhook/configuration"
require_relative "mailhook/errors"
require_relative "mailhook/response"
require_relative "mailhook/connection"
require_relative "mailhook/resource"
require_relative "mailhook/client"
require_relative "mailhook/resources/agents"
require_relative "mailhook/resources/domains"
require_relative "mailhook/resources/email_addresses"
require_relative "mailhook/resources/inbound_emails"
require_relative "mailhook/resources/webhooks"
require_relative "mailhook/resources/outbound_emails"

# Mailhook Ruby client for the Mailhook API.
#
# @example Configure and use the client
#   Mailhook.configure do |config|
#     config.agent_id = ENV["MAILHOOK_AGENT_ID"]
#     config.api_key = ENV["MAILHOOK_API_KEY"]
#   end
#
#   client = Mailhook.client
#   email = client.email_addresses.create_random(domain_id: "5")
#   puts email["address"]
module Mailhook
  class << self
    # @return [Configuration] The global configuration object
    attr_writer :configuration

    # Get the global configuration
    # @return [Configuration]
    def configuration
      @configuration ||= Configuration.new
    end

    # Configure the Mailhook client
    # @yield [Configuration] The configuration object
    # @return [Configuration]
    #
    # @example
    #   Mailhook.configure do |config|
    #     config.agent_id = "your_agent_id"
    #     config.api_key = "your_api_key"
    #     config.timeout = 60
    #   end
    def configure
      yield(configuration)
      configuration
    end

    # Reset the configuration to defaults
    # @return [void]
    def reset_configuration!
      @configuration = Configuration.new
    end

    # Create a new client using the global configuration
    # @return [Client]
    #
    # @example
    #   client = Mailhook.client
    #   client.agents.me
    def client
      Client.new
    end
  end
end
