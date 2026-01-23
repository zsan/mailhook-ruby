#!/usr/bin/env ruby
# frozen_string_literal: true

# Create Random Email Address with tail.me domain
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx bundle exec ruby examples/create_random_email.rb
#
# Or with custom slug:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx TAILME_SLUG=mybot bundle exec ruby examples/create_random_email.rb

require_relative "../lib/mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

# Step 1: Check existing domains or create new one
puts "Checking domains..."
domains = client.domains.list

if domains.empty?
  # Create a new shared domain with tail.me
  slug = ENV.fetch("TAILME_SLUG", "agent-#{SecureRandom.hex(4)}")
  puts "Creating domain: #{slug}.tail.me"

  domain = client.domains.create(slug: slug)
  domain_id = domain["id"]
  domain_name = domain.dig("attributes", "name") || domain["name"]
  puts "Created: #{domain_name}"
else
  domain = domains.first
  domain_id = domain["id"]
  domain_name = domain.dig("attributes", "name") || domain["name"]
  puts "Using existing domain: #{domain_name}"
end

# Step 2: Create random email address
puts "\nCreating random email address..."
email = client.email_addresses.create_random(domain_id: domain_id)

email_address = email["attributes"]&.dig("email") || email["email"] || email["address"]

puts "\n#{"=" * 50}"
puts "Email Address Created!"
puts "=" * 50
puts "ID:      #{email["id"]}"
puts "Address: #{email_address}"
puts "=" * 50
