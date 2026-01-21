# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.1] - 2024-01-21

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
