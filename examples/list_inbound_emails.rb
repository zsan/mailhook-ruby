#!/usr/bin/env ruby
# frozen_string_literal: true

# List inbound emails for an email address
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx EMAIL_ADDRESS_ID=ea_xxx bundle exec ruby examples/list_inbound_emails.rb

require_relative "../lib/mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

email_address_id = ENV.fetch("EMAIL_ADDRESS_ID", nil)

unless email_address_id
  # If no email address ID provided, list all email addresses and use the first one
  puts "No EMAIL_ADDRESS_ID provided. Listing email addresses..."
  puts

  email_addresses = client.email_addresses.list

  if email_addresses.empty?
    puts "No email addresses found. Create one first:"
    puts "  bundle exec ruby examples/create_random_email.rb"
    exit 1
  end

  first = email_addresses.first
  email_address_id = first["id"]
  email = first.dig("attributes", "email") || first["email"]
  puts "Using: #{email} (#{email_address_id})"
  puts
end

puts "Listing Inbound Emails"
puts "=" * 50

inbound_emails = client.inbound_emails.list(email_address_id: email_address_id)

if inbound_emails.empty?
  puts "No emails received yet."
  puts "Send an email to this address and run again."
else
  inbound_emails.each do |email|
    attrs = email["attributes"] || {}
    puts "ID: #{email["id"]}"
    puts "From: #{attrs["from"] || email["from"]}"
    puts "Subject: #{attrs["subject"] || email["subject"]}"
    puts "Received: #{attrs["received_at"] || attrs["created_at"]}"
    puts "Read: #{attrs["read"] || false}"
    puts "-" * 50
  end
  puts "Total: #{inbound_emails.count} email(s)"
end
