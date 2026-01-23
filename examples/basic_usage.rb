#!/usr/bin/env ruby
# frozen_string_literal: true

# Basic Usage Examples for mailhook-ruby
#
# This is a quick demo that shows the main workflow.
# For individual operations, see:
#   - list_domains.rb
#   - create_domain.rb
#   - create_random_email.rb
#   - list_inbound_emails.rb
#   - retrieve_email_detail.rb
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx bundle exec ruby examples/basic_usage.rb

require_relative "../lib/mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

puts "Mailhook Ruby - Basic Usage"
puts "=" * 50
puts

# 1. List domains
puts "1. Domains"
puts "-" * 40
domains = client.domains.list
if domains.empty?
  puts "No domains. Run: bundle exec ruby examples/create_domain.rb"
  exit 1
end
domain = domains.first
domain_name = domain.dig("attributes", "name")
puts "Using: #{domain_name} (ID: #{domain["id"]})"
puts

# 2. Create random email
puts "2. Create Random Email"
puts "-" * 40
email = client.email_addresses.create_random(domain_id: domain["id"])
email_addr = email["attributes"]&.dig("email")
puts "Created: #{email_addr}"
puts "ID: #{email["id"]}"
puts

# 3. Check for inbound emails
puts "3. Inbound Emails"
puts "-" * 40
inbound = client.inbound_emails.list(email_address_id: email["id"])
puts "Received: #{inbound.count} email(s)"
puts

puts "Done! Send an email to #{email_addr} and check with:"
puts "  EMAIL_ADDRESS_ID=#{email["id"]} bundle exec ruby examples/list_inbound_emails.rb"
