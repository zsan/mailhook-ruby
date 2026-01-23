#!/usr/bin/env ruby
# frozen_string_literal: true

# List all email addresses
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx bundle exec ruby examples/list_email_addresses.rb

require_relative "../lib/mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

puts "Listing Email Addresses"
puts "=" * 50

email_addresses = client.email_addresses.list

if email_addresses.empty?
  puts "No email addresses found. Create one with:"
  puts "  bundle exec ruby examples/create_random_email.rb"
else
  email_addresses.each do |ea|
    attrs = ea["attributes"] || {}
    email = attrs["email"] || ea["email"]
    domain = attrs["domain"] || ea["domain"]
    active = attrs["active"] || ea["active"]
    count = attrs["emails_received_count"] || 0

    puts "ID: #{ea["id"]}"
    puts "Email: #{email}"
    puts "Domain: #{domain}"
    puts "Active: #{active}"
    puts "Received: #{count} email(s)"
    puts "-" * 50
  end
  puts "Total: #{email_addresses.count} email address(es)"
end
