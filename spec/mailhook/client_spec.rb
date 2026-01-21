# frozen_string_literal: true

RSpec.describe Mailhook::Client do
  describe "#initialize" do
    it "creates a client with provided credentials" do
      client = described_class.new(agent_id: "my_agent", api_key: "my_key")

      expect(client.config.agent_id).to eq("my_agent")
      expect(client.config.api_key).to eq("my_key")
    end

    it "uses global configuration when no credentials provided" do
      Mailhook.configure do |config|
        config.agent_id = "global_agent"
        config.api_key = "global_key"
      end

      client = described_class.new

      expect(client.config.agent_id).to eq("global_agent")
      expect(client.config.api_key).to eq("global_key")
    end

    it "allows custom base_url" do
      client = described_class.new(base_url: "https://custom.api.com")

      expect(client.config.base_url).to eq("https://custom.api.com")
    end

    it "allows custom timeout" do
      client = described_class.new(timeout: 60)

      expect(client.config.timeout).to eq(60)
    end
  end

  describe "resources" do
    subject(:client) { described_class.new(agent_id: "test", api_key: "test") }

    describe "#agents" do
      it "returns an Agents resource" do
        expect(client.agents).to be_a(Mailhook::Resources::Agents)
      end

      it "returns the same instance on multiple calls" do
        expect(client.agents).to be(client.agents)
      end
    end

    describe "#domains" do
      it "returns a Domains resource" do
        expect(client.domains).to be_a(Mailhook::Resources::Domains)
      end
    end

    describe "#email_addresses" do
      it "returns an EmailAddresses resource" do
        expect(client.email_addresses).to be_a(Mailhook::Resources::EmailAddresses)
      end
    end

    describe "#inbound_emails" do
      it "returns an InboundEmails resource" do
        expect(client.inbound_emails).to be_a(Mailhook::Resources::InboundEmails)
      end
    end

    describe "#webhooks" do
      it "returns a Webhooks resource" do
        expect(client.webhooks).to be_a(Mailhook::Resources::Webhooks)
      end
    end

    describe "#outbound_emails" do
      it "returns an OutboundEmails resource" do
        expect(client.outbound_emails).to be_a(Mailhook::Resources::OutboundEmails)
      end
    end
  end
end
