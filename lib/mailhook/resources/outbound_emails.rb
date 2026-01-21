# frozen_string_literal: true

module Mailhook
  module Resources
    # Resource for sending outbound emails.
    #
    # @example Send an email
    #   email = client.outbound_emails.send(
    #     from_email_address_id: "123",
    #     to: "user@example.com",
    #     subject: "Hello!",
    #     body: "This is a test email."
    #   )
    #   puts email["id"]
    #
    # @example Retrieve a sent email
    #   email = client.outbound_emails.retrieve("456")
    #   puts email["status"]
    class OutboundEmails < Resource
      # Send an outbound email
      # @param from_email_address_id [String, Integer] ID of the email address to send from
      # @param to [String] Recipient email address
      # @param subject [String] Email subject
      # @param body [String] Email body (plain text)
      # @param html_body [String, nil] Email body (HTML)
      # @param reply_to [String, nil] Reply-to address
      # @return [Response] Sent email details
      def send(from_email_address_id:, to:, subject:, body:, html_body: nil, reply_to: nil)
        post("outbound_emails", clean_params({
                                               from_email_address_id: from_email_address_id,
                                               to: to,
                                               subject: subject,
                                               body: body,
                                               html_body: html_body,
                                               reply_to: reply_to
                                             }))
      end

      # Retrieve an outbound email by ID
      # @param id [String, Integer] Outbound email ID
      # @return [Response] Outbound email details including delivery status
      def retrieve(id)
        get("outbound_emails/#{id}")
      end

      # List outbound emails
      # @param from_email_address_id [String, Integer, nil] Filter by sender email address
      # @param page [Integer, nil] Page number
      # @param per_page [Integer, nil] Items per page
      # @return [Response] List of outbound emails
      def list(from_email_address_id: nil, page: nil, per_page: nil)
        get("outbound_emails", clean_params({
                                              from_email_address_id: from_email_address_id,
                                              page: page,
                                              per_page: per_page
                                            }))
      end
    end
  end
end
