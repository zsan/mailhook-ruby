#!/usr/bin/env ruby
# frozen_string_literal: true

# Retrieve full email detail
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx EMAIL_ID=ie_xxx bundle exec ruby examples/retrieve_email_detail.rb

require_relative "../lib/mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

email_id = ENV.fetch("EMAIL_ID") do
  puts "Usage: EMAIL_ID=ie_xxx bundle exec ruby examples/retrieve_email_detail.rb"
  puts
  puts "Get EMAIL_ID from:"
  puts "  bundle exec ruby examples/list_inbound_emails.rb"
  exit 1
end

puts "Retrieving Email Detail"
puts "=" * 50

begin
  email = client.inbound_emails.retrieve(email_id)
  attrs = email["attributes"] || {}

  puts "ID: #{email["id"]}"
  puts "From: #{attrs["from"] || email["from"]}"
  puts "To: #{attrs["to"] || email["to"]}"
  puts "Subject: #{attrs["subject"] || email["subject"]}"
  puts "Received: #{attrs["received_at"] || attrs["created_at"]}"
  puts
  puts "Body (text):"
  puts "-" * 50
  puts attrs["text_body"] || attrs["body"] || email["body"] || "(no text body)"
  puts
  puts "Body (html):"
  puts "-" * 50
  puts attrs["html_body"] || "(no html body)"
rescue Mailhook::NotFoundError
  puts "Email not found: #{email_id}"
  puts "It may have been deleted or expired (retention period)."
end
