#!/usr/bin/env ruby
# frozen_string_literal: true

# Basic Usage Examples for mailhook-ruby
#
# Run with:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx bundle exec ruby examples/basic_usage.rb
#
# Or use in IRB:
#   MAILHOOK_AGENT_ID=xxx MAILHOOK_API_KEY=xxx bundle exec irb -r ./lib/mailhook

require_relative "../lib/mailhook"

# ============================================================
# Configuration
# ============================================================

Mailhook.configure do |config|
  config.agent_id = ENV.fetch("MAILHOOK_AGENT_ID")
  config.api_key = ENV.fetch("MAILHOOK_API_KEY")
end

client = Mailhook.client

# ============================================================
# 1. List Domains
# ============================================================
# Get available domains to obtain domain_id for creating emails

puts "1. List Domains"
puts "-" * 40

domains = client.domains.list
domains.each do |domain|
  puts "ID: #{domain["id"]}, Domain: #{domain["domain"]}"
end

domain_id = domains.first["id"]
puts "Using domain_id: #{domain_id}"
puts

# ============================================================
# 2. Create Random Email
# ============================================================
# Create a unique email address for signup/automation

puts "2. Create Random Email"
puts "-" * 40

email_address = client.email_addresses.create_random(domain_id: domain_id)
puts "ID: #{email_address["id"]}"
puts "Address: #{email_address["address"]}"
puts

# ============================================================
# 3. List Inbound Emails
# ============================================================
# Check if any emails have been received

puts "3. List Inbound Emails"
puts "-" * 40

inbound_emails = client.inbound_emails.list(email_address_id: email_address["id"])
puts "Total emails: #{inbound_emails.count}"

inbound_emails.each do |email|
  puts "- ID: #{email["id"]}, From: #{email["from"]}, Subject: #{email["subject"]}"
end
puts

# ============================================================
# 4. Retrieve Email Detail
# ============================================================
# Get full email content including body

puts "4. Retrieve Email Detail"
puts "-" * 40

if inbound_emails.any?
  email_id = inbound_emails.first["id"]
  email_detail = client.inbound_emails.retrieve(email_id)

  puts "From: #{email_detail["from"]}"
  puts "Subject: #{email_detail["subject"]}"
  puts "Body:"
  puts email_detail["body"]
else
  puts "No emails to retrieve"
end
puts

# ============================================================
# 5. Delete Email Address
# ============================================================
# Cleanup - delete the email address when done

puts "5. Delete Email Address"
puts "-" * 40

client.email_addresses.delete(email_address["id"])
puts "Deleted: #{email_address["address"]}"
