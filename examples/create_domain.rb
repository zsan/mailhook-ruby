#!/usr/bin/env ruby
# frozen_string_literal: true

# Create a new shared domain (tail.me subdomain)
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx bundle exec ruby examples/create_domain.rb
#
# Or with custom slug:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx TAILME_SLUG=mybot bundle exec ruby examples/create_domain.rb

require_relative "../lib/mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

slug = ENV.fetch("TAILME_SLUG", "agent-#{SecureRandom.hex(4)}")

puts "Creating Domain"
puts "=" * 50
puts "Slug: #{slug}"
puts "Domain: #{slug}.tail.me"
puts

begin
  domain = client.domains.create(slug: slug)

  name = domain.dig("attributes", "name") || domain["name"]
  status = domain.dig("attributes", "verification_status") || "unknown"

  puts "Success!"
  puts "-" * 50
  puts "ID: #{domain["id"]}"
  puts "Domain: #{name}"
  puts "Status: #{status}"
rescue Mailhook::UnprocessableEntityError => e
  puts "Error: #{e.message}"
  puts "The slug might already be taken. Try a different one:"
  puts "  TAILME_SLUG=another-name bundle exec ruby examples/create_domain.rb"
end
