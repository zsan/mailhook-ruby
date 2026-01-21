# frozen_string_literal: true

require "mailhook"
require "webmock/rspec"

# Disable all external HTTP connections in tests
WebMock.disable_net_connect!

# VCR is available for integration tests but not loaded by default
# To use VCR, require it in the specific test file and configure as needed

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random
  Kernel.srand config.seed

  config.before do
    Mailhook.reset_configuration!
  end
end
