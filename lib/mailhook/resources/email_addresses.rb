# frozen_string_literal: true

module Mailhook
  module Resources
    # Resource for managing email addresses.
    #
    # @example Create a random email address
    #   email = client.email_addresses.create_random(domain_id: "5")
    #   puts email["address"]  # => "abc123@example.tail.me"
    #
    # @example Create a specific email address
    #   email = client.email_addresses.create(
    #     domain_id: "5",
    #     local_part: "support"
    #   )
    #   puts email["address"]  # => "support@example.tail.me"
    class EmailAddresses < Resource
      # Create a new email address with a specific local part
      # @param domain_id [String, Integer] Domain ID
      # @param local_part [String] Local part of the email (before @)
      # @return [Response] Created email address details
      def create(domain_id:, local_part:)
        post("email_addresses", { domain_id: domain_id, local_part: local_part })
      end

      # Create a random email address
      # @param domain_id [String, Integer] Domain ID
      # @return [Response] Created email address with random local part
      def create_random(domain_id:)
        post("email_addresses/random", { domain_id: domain_id })
      end

      # List all email addresses
      # @param domain_id [String, Integer, nil] Filter by domain
      # @param page [Integer, nil] Page number
      # @param per_page [Integer, nil] Items per page
      # @return [Response] List of email addresses
      def list(domain_id: nil, page: nil, per_page: nil)
        get("email_addresses", clean_params({ domain_id: domain_id, page: page, per_page: per_page }))
      end

      # Retrieve an email address by ID
      # @param id [String, Integer] Email address ID
      # @return [Response] Email address details
      def retrieve(id)
        get("email_addresses/#{id}")
      end

      # Delete an email address
      # @param id [String, Integer] Email address ID
      # @return [Response] Deletion confirmation
      def delete(id)
        super("email_addresses/#{id}")
      end

      # Batch create multiple email addresses (Pro feature)
      # @param email_addresses [Array<Hash>] Array of email address params
      # @return [Response] Created email addresses
      def batch_create(email_addresses)
        post("email_addresses/batch", { email_addresses: email_addresses })
      end

      # Batch delete multiple email addresses (Pro feature)
      # @param ids [Array<String, Integer>] Array of email address IDs
      # @return [Response] Deletion confirmation
      def batch_delete(ids)
        delete("email_addresses/batch", { ids: ids })
      end

      # Stream email addresses using Server-Sent Events (Pro feature)
      # @param domain_id [String, Integer, nil] Filter by domain
      # @yield [Hash] Each email address as it arrives
      # @note This method blocks until the stream is closed or interrupted
      def stream(domain_id: nil)
        raise ArgumentError, "Block required for streaming" unless block_given?

        params = clean_params({ domain_id: domain_id })
        # NOTE: Streaming requires special handling and may need custom implementation
        # depending on how the API implements SSE
        get("email_addresses/stream", params)
      end
    end
  end
end
