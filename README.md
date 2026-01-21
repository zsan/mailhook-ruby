# Mailhook Ruby

> **Beta Notice:** This gem is currently in beta (v0.0.1). API may change in future releases.

Ruby client library for the [Mailhook API](https://mailhook.dev).

## Requirements

- Ruby >= 3.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem "mailhook"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install mailhook
```

## Configuration

Configure the client with your Mailhook credentials:

```ruby
require "mailhook"

Mailhook.configure do |config|
  config.agent_id = ENV["MAILHOOK_AGENT_ID"]
  config.api_key = ENV["MAILHOOK_API_KEY"]
end

client = Mailhook.client
```

Or create a client instance directly:

```ruby
client = Mailhook::Client.new(
  agent_id: "your_agent_id",
  api_key: "your_api_key"
)
```

### Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `agent_id` | `nil` | Your Mailhook Agent ID |
| `api_key` | `nil` | Your Mailhook API Key |
| `base_url` | `https://api.mailhook.dev/api/v1` | API base URL |
| `timeout` | `30` | Request timeout in seconds |
| `open_timeout` | `10` | Connection timeout in seconds |
| `max_retries` | `2` | Maximum retry attempts |

## Usage

### Agents

```ruby
# Register a new agent
response = client.agents.register(name: "My Test Agent")
puts response["agent_id"]
puts response["api_key"]

# Get current agent info
me = client.agents.me
puts me["name"]
puts me["plan"]

# Upgrade to Pro
client.agents.upgrade

# Check upgrade status
status = client.agents.upgrade_status

# Deactivate agent
client.agents.deactivate
```

### Domains

```ruby
# Check if slug is available
available = client.domains.check_slug("mycompany")
puts available["available"]

# Create a domain
domain = client.domains.create(slug: "mycompany")
puts domain["domain"]  # => "mycompany.tail.me"

# List domains
domains = client.domains.list
domains.each { |d| puts d["domain"] }

# Retrieve a domain
domain = client.domains.retrieve("123")

# Delete a domain
client.domains.delete("123")
```

### Email Addresses

```ruby
# Create a specific email address
email = client.email_addresses.create(
  domain_id: "5",
  local_part: "support"
)
puts email["address"]  # => "support@example.tail.me"

# Create a random email address
email = client.email_addresses.create_random(domain_id: "5")
puts email["address"]  # => "abc123@example.tail.me"

# List email addresses
emails = client.email_addresses.list(domain_id: "5")
emails.each { |e| puts e["address"] }

# Retrieve an email address
email = client.email_addresses.retrieve("123")

# Delete an email address
client.email_addresses.delete("123")

# Batch create (Pro feature)
emails = client.email_addresses.batch_create([
  { domain_id: "5", local_part: "sales" },
  { domain_id: "5", local_part: "support" }
])

# Batch delete (Pro feature)
client.email_addresses.batch_delete(["123", "456"])
```

### Inbound Emails

```ruby
# List inbound emails
emails = client.inbound_emails.list(email_address_id: "123")
emails.each do |email|
  puts "From: #{email['from']}"
  puts "Subject: #{email['subject']}"
end

# Filter by read status
unread = client.inbound_emails.list(read: false)

# Retrieve an inbound email (includes body)
email = client.inbound_emails.retrieve("456")
puts email["body"]

# Mark as read
client.inbound_emails.mark_read("456")

# Batch mark as read (Pro feature)
client.inbound_emails.batch_mark_read(["456", "789"])

# Batch delete (Pro feature)
client.inbound_emails.batch_delete(["456", "789"])
```

### Webhooks

```ruby
# Create a webhook
webhook = client.webhooks.create(
  url: "https://example.com/webhook",
  email_address_id: "123",
  secret: "my_webhook_secret"
)

# List webhooks
webhooks = client.webhooks.list
webhooks.each { |w| puts w["url"] }

# Retrieve a webhook
webhook = client.webhooks.retrieve("789")

# Delete a webhook
client.webhooks.delete("789")
```

### Outbound Emails

```ruby
# Send an email
email = client.outbound_emails.send(
  from_email_address_id: "123",
  to: "user@example.com",
  subject: "Hello!",
  body: "This is a test email."
)
puts email["id"]
puts email["status"]

# Send with HTML body
email = client.outbound_emails.send(
  from_email_address_id: "123",
  to: "user@example.com",
  subject: "Hello!",
  body: "Plain text version",
  html_body: "<h1>HTML version</h1>"
)

# List sent emails
emails = client.outbound_emails.list(from_email_address_id: "123")

# Retrieve sent email status
email = client.outbound_emails.retrieve("456")
puts email["status"]  # => "delivered"
```

## Error Handling

The gem raises specific exceptions for different error conditions:

```ruby
begin
  client.email_addresses.retrieve(999999)
rescue Mailhook::AuthenticationError => e
  puts "Invalid credentials: #{e.message}"
rescue Mailhook::NotFoundError => e
  puts "Not found: #{e.message}"
rescue Mailhook::RateLimitError => e
  puts "Rate limited. Retry after #{e.retry_after} seconds"
  sleep(e.retry_after)
  retry
rescue Mailhook::BadRequestError => e
  puts "Bad request: #{e.message}"
rescue Mailhook::ForbiddenError => e
  puts "Forbidden: #{e.message}"
rescue Mailhook::UnprocessableEntityError => e
  puts "Validation failed: #{e.errors}"
rescue Mailhook::ServerError => e
  puts "Server error: #{e.message}"
rescue Mailhook::ConnectionError => e
  puts "Connection failed: #{e.message}"
rescue Mailhook::TimeoutError => e
  puts "Request timed out: #{e.message}"
end
```

### Error Classes

| Error | HTTP Status | Description |
|-------|-------------|-------------|
| `AuthenticationError` | 401 | Invalid or missing credentials |
| `ForbiddenError` | 403 | Access denied |
| `NotFoundError` | 404 | Resource not found |
| `BadRequestError` | 400 | Invalid request |
| `ConflictError` | 409 | Resource conflict |
| `UnprocessableEntityError` | 422 | Validation failed |
| `RateLimitError` | 429 | Rate limit exceeded |
| `ServerError` | 5xx | Server error |
| `ConnectionError` | - | Connection failed |
| `TimeoutError` | - | Request timed out |

## Response Objects

All API responses are wrapped in a `Mailhook::Response` object that provides hash-like access:

```ruby
response = client.email_addresses.retrieve("123")

# Access data
response["id"]
response["address"]

# Check success
response.success?

# Get raw data
response.data

# For list responses
response = client.inbound_emails.list
response.each { |email| puts email["subject"] }
response.count
response.first
response.last
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests.

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop

# Run all checks
bundle exec rake
```

## Architecture

For detailed information about the internal architecture, see [ARCHITECTURE.md](ARCHITECTURE.md).

This documentation is designed for both human developers and AI agents to understand:
- Directory structure and file responsibilities
- Request/response flow
- How to add new endpoints
- Error handling patterns
- Testing patterns

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`bundle exec rspec`)
5. Ensure code style is correct (`bundle exec rubocop`)
6. Commit your changes (`git commit -am 'Add my feature'`)
7. Push to the branch (`git push origin feature/my-feature`)
8. Create a Pull Request

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Author

- **Zakarias** - [zaksantanu@gmail.com](mailto:zaksantanu@gmail.com)
