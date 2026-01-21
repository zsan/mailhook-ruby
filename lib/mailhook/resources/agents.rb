# frozen_string_literal: true

module Mailhook
  module Resources
    # Resource for managing agents.
    #
    # @example Register a new agent
    #   response = client.agents.register(name: "My Agent")
    #   puts response["agent_id"]
    #   puts response["api_key"]
    #
    # @example Get current agent info
    #   me = client.agents.me
    #   puts me["name"]
    class Agents < Resource
      # Register a new agent
      # @param name [String] Name for the agent
      # @return [Response] Contains agent_id and api_key
      def register(name:)
        post("agents/register", { name: name })
      end

      # Get current agent information
      # @return [Response] Agent details
      def me
        get("agents/me")
      end

      # Upgrade agent to Pro plan
      # @return [Response] Upgrade status with checkout URL
      def upgrade
        post("agents/upgrade")
      end

      # Check upgrade status
      # @return [Response] Current plan status
      def upgrade_status
        get("agents/upgrade/status")
      end

      # Deactivate the current agent
      # @return [Response] Deactivation confirmation
      def deactivate
        delete("agents/me")
      end
    end
  end
end
