# frozen_string_literal: true

module Mailhook
  module Resources
    # Resource for managing webhooks.
    #
    # @example Create a webhook
    #   webhook = client.webhooks.create(
    #     url: "https://example.com/webhook",
    #     email_address_id: "123"
    #   )
    #   puts webhook["id"]
    #
    # @example List webhooks
    #   webhooks = client.webhooks.list
    #   webhooks.each { |w| puts w["url"] }
    class Webhooks < Resource
      # Create a new webhook
      # @param url [String] The webhook URL to receive notifications
      # @param email_address_id [String, Integer, nil] Filter to specific email address
      # @param domain_id [String, Integer, nil] Filter to specific domain
      # @param secret [String, nil] Secret for webhook signature verification
      # @return [Response] Created webhook details
      def create(url:, email_address_id: nil, domain_id: nil, secret: nil)
        post("webhooks", clean_params({
                                        url: url,
                                        email_address_id: email_address_id,
                                        domain_id: domain_id,
                                        secret: secret
                                      }))
      end

      # List all webhooks
      # @param email_address_id [String, Integer, nil] Filter by email address
      # @param domain_id [String, Integer, nil] Filter by domain
      # @param page [Integer, nil] Page number
      # @param per_page [Integer, nil] Items per page
      # @return [Response] List of webhooks
      def list(email_address_id: nil, domain_id: nil, page: nil, per_page: nil)
        get("webhooks", clean_params({
                                       email_address_id: email_address_id,
                                       domain_id: domain_id,
                                       page: page,
                                       per_page: per_page
                                     }))
      end

      # Retrieve a webhook by ID
      # @param id [String, Integer] Webhook ID
      # @return [Response] Webhook details
      def retrieve(id)
        get("webhooks/#{id}")
      end

      # Delete a webhook
      # @param id [String, Integer] Webhook ID
      # @return [Response] Deletion confirmation
      def delete(id)
        super("webhooks/#{id}")
      end
    end
  end
end
