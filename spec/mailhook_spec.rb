# frozen_string_literal: true

RSpec.describe Mailhook do
  describe ".configure" do
    it "yields the configuration object" do
      expect { |b| described_class.configure(&b) }.to yield_with_args(Mailhook::Configuration)
    end

    it "sets configuration values" do
      described_class.configure do |config|
        config.agent_id = "test_agent"
        config.api_key = "test_key"
      end

      expect(described_class.configuration.agent_id).to eq("test_agent")
      expect(described_class.configuration.api_key).to eq("test_key")
    end
  end

  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(Mailhook::Configuration)
    end

    it "returns the same instance on multiple calls" do
      config1 = described_class.configuration
      config2 = described_class.configuration
      expect(config1).to be(config2)
    end
  end

  describe ".reset_configuration!" do
    it "resets configuration to defaults" do
      described_class.configure do |config|
        config.agent_id = "test_agent"
        config.api_key = "test_key"
      end

      described_class.reset_configuration!

      expect(described_class.configuration.agent_id).to be_nil
      expect(described_class.configuration.api_key).to be_nil
    end
  end

  describe ".client" do
    it "returns a Client instance" do
      expect(described_class.client).to be_a(Mailhook::Client)
    end

    it "uses global configuration" do
      described_class.configure do |config|
        config.agent_id = "global_agent"
        config.api_key = "global_key"
      end

      client = described_class.client
      expect(client.config.agent_id).to eq("global_agent")
      expect(client.config.api_key).to eq("global_key")
    end
  end

  describe "VERSION" do
    it "has a version number" do
      expect(Mailhook::VERSION).not_to be_nil
      expect(Mailhook::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end
end
