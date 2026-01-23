#!/usr/bin/env ruby
# frozen_string_literal: true

# Delete an email address
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx EMAIL_ADDRESS_ID=ea_xxx bundle exec ruby examples/delete_email_address.rb

require_relative "../lib/mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

email_address_id = ENV.fetch("EMAIL_ADDRESS_ID") do
  puts "Usage: EMAIL_ADDRESS_ID=ea_xxx bundle exec ruby examples/delete_email_address.rb"
  puts
  puts "Get EMAIL_ADDRESS_ID from:"
  puts "  bundle exec ruby examples/list_email_addresses.rb"
  exit 1
end

puts "Deleting Email Address"
puts "=" * 50
puts "ID: #{email_address_id}"
puts

begin
  # Get email details first
  email = client.email_addresses.retrieve(email_address_id)
  email_addr = email["attributes"]&.dig("email") || email["email"]
  puts "Email: #{email_addr}"
  puts

  # Delete
  client.email_addresses.delete(email_address_id)
  puts "Deleted successfully!"
rescue Mailhook::NotFoundError
  puts "Error: Email address not found."
  puts "It may have already been deleted or expired."
end
