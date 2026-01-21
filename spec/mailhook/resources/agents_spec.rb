# frozen_string_literal: true

RSpec.describe Mailhook::Resources::Agents do
  let(:client) { Mailhook::Client.new(agent_id: "test_agent", api_key: "test_key") }
  let(:agents) { client.agents }

  describe "#register" do
    before do
      stub_request(:post, "https://api.mailhook.dev/api/v1/agents/register")
        .with(body: { name: "My Agent" }.to_json)
        .to_return(
          status: 201,
          body: { agent_id: "new_agent_123", api_key: "new_key_456" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "registers a new agent" do
      response = agents.register(name: "My Agent")

      expect(response["agent_id"]).to eq("new_agent_123")
      expect(response["api_key"]).to eq("new_key_456")
    end
  end

  describe "#me" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/agents/me")
        .to_return(
          status: 200,
          body: { id: "test_agent", name: "Test Agent", plan: "free" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns current agent info" do
      response = agents.me

      expect(response["id"]).to eq("test_agent")
      expect(response["name"]).to eq("Test Agent")
      expect(response["plan"]).to eq("free")
    end
  end

  describe "#upgrade" do
    before do
      stub_request(:post, "https://api.mailhook.dev/api/v1/agents/upgrade")
        .to_return(
          status: 200,
          body: { checkout_url: "https://checkout.stripe.com/..." }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "initiates upgrade to Pro" do
      response = agents.upgrade

      expect(response["checkout_url"]).to start_with("https://checkout.stripe.com")
    end
  end

  describe "#upgrade_status" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/agents/upgrade/status")
        .to_return(
          status: 200,
          body: { plan: "pro", status: "active" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns upgrade status" do
      response = agents.upgrade_status

      expect(response["plan"]).to eq("pro")
      expect(response["status"]).to eq("active")
    end
  end

  describe "#deactivate" do
    before do
      stub_request(:delete, "https://api.mailhook.dev/api/v1/agents/me")
        .to_return(
          status: 200,
          body: { message: "Agent deactivated" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "deactivates the agent" do
      response = agents.deactivate

      expect(response["message"]).to eq("Agent deactivated")
    end
  end
end
