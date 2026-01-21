# Architecture Documentation

This document explains the internal architecture of `mailhook-ruby` gem for developers and AI agents.

## Directory Structure

```
lib/
├── mailhook.rb              # Entry point - loads all modules, provides Mailhook.configure and Mailhook.client
└── mailhook/
    ├── version.rb           # VERSION constant
    ├── configuration.rb     # Stores API credentials and settings
    ├── errors.rb            # Exception hierarchy
    ├── response.rb          # Wraps API responses with hash-like access
    ├── connection.rb        # Faraday HTTP client setup
    ├── resource.rb          # Base class for all API resources
    ├── client.rb            # Main client that orchestrates resources
    └── resources/           # API endpoint implementations
        ├── agents.rb
        ├── domains.rb
        ├── email_addresses.rb
        ├── inbound_emails.rb
        ├── webhooks.rb
        └── outbound_emails.rb
```

## Request Flow

```
User Code
    │
    ▼
Mailhook.client (creates Client instance)
    │
    ▼
Client#agents/domains/etc (returns Resource instance)
    │
    ▼
Resource#method (e.g., agents.me)
    │
    ▼
Resource#get/post/patch/delete (inherited from base Resource)
    │
    ▼
Connection#request (Faraday HTTP call)
    │
    ▼
Connection#handle_response
    │
    ├── Success: Returns Response object
    │
    └── Error: Raises appropriate Mailhook::*Error
```

## Key Classes

### Configuration (`lib/mailhook/configuration.rb`)

Stores global settings. Key attributes:
- `agent_id` - Authentication header X-Agent-ID
- `api_key` - Authentication header X-API-Key
- `base_url` - API endpoint (default: `https://api.mailhook.dev/api/v1`)
- `timeout` - Request timeout in seconds
- `max_retries` - Retry count for failed requests

### Connection (`lib/mailhook/connection.rb`)

Handles HTTP communication using Faraday. Key responsibilities:
- Sets up Faraday connection with auth headers
- Configures retry middleware
- Maps HTTP status codes to exception classes
- Parses JSON responses

**Status code to exception mapping:**
| Status | Exception |
|--------|-----------|
| 400 | BadRequestError |
| 401 | AuthenticationError |
| 403 | ForbiddenError |
| 404 | NotFoundError |
| 409 | ConflictError |
| 422 | UnprocessableEntityError |
| 429 | RateLimitError |
| 5xx | ServerError |

### Response (`lib/mailhook/response.rb`)

Wraps API responses. Provides:
- Hash-like access: `response["id"]` or `response[:id]`
- Enumerable for list responses: `response.each { |item| ... }`
- Metadata access: `response.meta` for pagination info
- Data extraction: Automatically unwraps `{"data": [...]}` format

### Resource (`lib/mailhook/resource.rb`)

Base class for API resources. Provides:
- `get(path, params)` - GET request
- `post(path, params)` - POST request
- `patch(path, params)` - PATCH request
- `delete(path, params)` - DELETE request
- `clean_params(hash)` - Removes nil values from params

### Client (`lib/mailhook/client.rb`)

Main entry point. Creates and caches resource instances:
- `client.agents` → Resources::Agents
- `client.domains` → Resources::Domains
- `client.email_addresses` → Resources::EmailAddresses
- `client.inbound_emails` → Resources::InboundEmails
- `client.webhooks` → Resources::Webhooks
- `client.outbound_emails` → Resources::OutboundEmails

## Adding New Endpoints

To add a new API endpoint:

1. **Create resource file** in `lib/mailhook/resources/`:
```ruby
# lib/mailhook/resources/new_resource.rb
module Mailhook
  module Resources
    class NewResource < Resource
      def list(page: nil)
        get("new_resources", clean_params({ page: page }))
      end

      def create(name:)
        post("new_resources", { name: name })
      end

      def retrieve(id)
        get("new_resources/#{id}")
      end

      def delete(id)
        super("new_resources/#{id}")
      end
    end
  end
end
```

2. **Add require** in `lib/mailhook.rb`:
```ruby
require_relative "mailhook/resources/new_resource"
```

3. **Add accessor** in `lib/mailhook/client.rb`:
```ruby
def new_resources
  @new_resources ||= Resources::NewResource.new(connection)
end
```

4. **Add tests** in `spec/mailhook/resources/new_resource_spec.rb`

## API Response Format

The Mailhook API returns responses in these formats:

**Single resource:**
```json
{
  "id": "123",
  "name": "example"
}
```

**List of resources:**
```json
{
  "data": [
    {"id": "1", "name": "first"},
    {"id": "2", "name": "second"}
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "per_page": 20
  }
}
```

The `Response` class automatically handles both formats.

## Error Handling

All errors inherit from `Mailhook::Error`. Each error has:
- `message` - Human readable error message
- `response` - Original Faraday response
- `status` - HTTP status code
- `body` - Parsed response body

Special error attributes:
- `RateLimitError#retry_after` - Seconds to wait before retry
- `UnprocessableEntityError#errors` - Validation error details

## Testing

Tests use WebMock to stub HTTP requests:

```ruby
before do
  stub_request(:get, "https://api.mailhook.dev/api/v1/agents/me")
    .to_return(
      status: 200,
      body: { id: "123", name: "Test" }.to_json,
      headers: { "Content-Type" => "application/json" }
    )
end
```

Run tests: `bundle exec rspec`
Run linter: `bundle exec rubocop`

## Dependencies

- `faraday` (>= 1.0, < 3.0) - HTTP client
- `faraday-retry` (~> 2.0) - Retry middleware

## Future Improvements

- [ ] SSE streaming support for real-time endpoints
- [ ] Webhook signature verification helper
- [ ] Async/concurrent request support
- [ ] Response caching
- [ ] Rate limit handling with automatic retry
