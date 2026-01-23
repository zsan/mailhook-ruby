# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.5] - 2026-01-23

### Fixed
- Fix `inbound_emails.list` endpoint to use `/email_addresses/:id/inbound_emails`

### Added
- `list_email_addresses.rb` example
- `delete_email_address.rb` example

## [0.0.4] - 2026-01-23

### Fixed
- Fix `domains.create` to use correct API format (`domain_type` + `tailme_slug`)
- Update examples to handle JSON:API response format with `attributes`

### Added
- Split examples into separate scripts:
  - `list_domains.rb` - List all domains
  - `create_domain.rb` - Create a new shared domain
  - `create_random_email.rb` - Create a random email address
  - `list_inbound_emails.rb` - List received emails
  - `retrieve_email_detail.rb` - Get full email content
- Save `docs/llms.txt` for LLM reference

## [0.0.3] - 2026-01-23

### Fixed
- Fix API subdomain from `api.mailhook.co` to `app.mailhook.co`

## [0.0.2] - 2026-01-23

### Fixed
- Fix incorrect API domain from `mailhook.dev` to `mailhook.co`

## [0.0.1] - 2026-01-22

### Added
- Initial release (beta)
- Core client with global configuration
- Authentication via X-Agent-ID and X-API-Key headers
- Resources:
  - Agents: register, me, upgrade, upgrade_status, deactivate
  - Domains: create, list, retrieve, delete, check_slug
  - EmailAddresses: create, create_random, list, retrieve, delete, batch_create, batch_delete
  - InboundEmails: list, retrieve, mark_read, batch_mark_read, batch_delete
  - Webhooks: create, list, retrieve, delete
  - OutboundEmails: send, retrieve, list
- Error handling with typed exceptions
- Response wrapper with hash-like access
- Faraday HTTP client with retry support
- RSpec test suite

### Notes
- This is a beta release, API may change
- SSE streaming endpoints are defined but not fully implemented
