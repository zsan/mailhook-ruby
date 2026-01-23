#!/usr/bin/env ruby
# frozen_string_literal: true

# List all domains
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx bundle exec ruby examples/list_domains.rb

require_relative "../lib/mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

puts "Listing Domains"
puts "=" * 50

domains = client.domains.list

if domains.empty?
  puts "No domains found. Create one with:"
  puts "  bundle exec ruby examples/create_domain.rb"
else
  domains.each do |domain|
    name = domain.dig("attributes", "name") || domain["domain"]
    status = domain.dig("attributes", "verification_status") || "unknown"
    puts "ID: #{domain["id"]}"
    puts "Domain: #{name}"
    puts "Status: #{status}"
    puts "-" * 50
  end
  puts "Total: #{domains.count} domain(s)"
end
