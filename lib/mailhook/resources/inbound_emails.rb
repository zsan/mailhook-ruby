# frozen_string_literal: true

module Mailhook
  module Resources
    # Resource for managing inbound emails.
    #
    # @example List inbound emails
    #   emails = client.inbound_emails.list(email_address_id: "123")
    #   emails.each { |e| puts e["subject"] }
    #
    # @example Mark email as read
    #   client.inbound_emails.mark_read("456")
    class InboundEmails < Resource
      # List inbound emails for an email address
      # @param email_address_id [String, Integer] Email address ID (required)
      # @param unread [Boolean, nil] Filter by unread status
      # @param page [Integer, nil] Page number
      # @param per_page [Integer, nil] Items per page
      # @return [Response] List of inbound emails
      def list(email_address_id:, unread: nil, page: nil, per_page: nil)
        get("email_addresses/#{email_address_id}/inbound_emails", clean_params({
                                                                                 unread: unread,
                                                                                 page: page,
                                                                                 per_page: per_page
                                                                               }))
      end

      # Retrieve an inbound email by ID
      # @param id [String, Integer] Inbound email ID
      # @return [Response] Inbound email details including body
      def retrieve(id)
        get("inbound_emails/#{id}")
      end

      # Mark an inbound email as read
      # @param id [String, Integer] Inbound email ID
      # @return [Response] Updated email with read status
      def mark_read(id)
        patch("inbound_emails/#{id}/read")
      end

      # Batch mark multiple emails as read (Pro feature)
      # @param ids [Array<String, Integer>] Array of email IDs
      # @return [Response] Update confirmation
      def batch_mark_read(ids)
        patch("inbound_emails/batch/read", { ids: ids })
      end

      # Batch delete multiple inbound emails (Pro feature)
      # @param ids [Array<String, Integer>] Array of email IDs
      # @return [Response] Deletion confirmation
      def batch_delete(ids)
        delete("inbound_emails/batch", { ids: ids })
      end

      # Stream inbound emails using Server-Sent Events (Pro feature)
      # @param email_address_id [String, Integer, nil] Filter by email address
      # @param domain_id [String, Integer, nil] Filter by domain
      # @yield [Hash] Each email as it arrives
      # @note This method blocks until the stream is closed or interrupted
      def stream(email_address_id: nil, domain_id: nil)
        raise ArgumentError, "Block required for streaming" unless block_given?

        params = clean_params({ email_address_id: email_address_id, domain_id: domain_id })
        get("inbound_emails/stream", params)
      end
    end
  end
end
