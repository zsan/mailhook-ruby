# frozen_string_literal: true

RSpec.describe Mailhook::Resources::Webhooks do
  let(:client) { Mailhook::Client.new(agent_id: "test_agent", api_key: "test_key") }
  let(:webhooks) { client.webhooks }

  describe "#create" do
    before do
      stub_request(:post, "https://api.mailhook.co/api/v1/webhooks")
        .with(body: { url: "https://example.com/webhook", email_address_id: "123" }.to_json)
        .to_return(
          status: 201,
          body: { id: "1", url: "https://example.com/webhook" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "creates a webhook" do
      response = webhooks.create(url: "https://example.com/webhook", email_address_id: "123")

      expect(response["id"]).to eq("1")
      expect(response["url"]).to eq("https://example.com/webhook")
    end
  end

  describe "#list" do
    before do
      stub_request(:get, "https://api.mailhook.co/api/v1/webhooks")
        .to_return(
          status: 200,
          body: { data: [{ id: "1", url: "https://example.com/webhook" }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "lists webhooks" do
      response = webhooks.list

      expect(response.count).to eq(1)
    end
  end

  describe "#retrieve" do
    before do
      stub_request(:get, "https://api.mailhook.co/api/v1/webhooks/1")
        .to_return(
          status: 200,
          body: { id: "1", url: "https://example.com/webhook" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "retrieves a webhook" do
      response = webhooks.retrieve("1")

      expect(response["id"]).to eq("1")
    end
  end

  describe "#delete" do
    before do
      stub_request(:delete, "https://api.mailhook.co/api/v1/webhooks/1")
        .to_return(
          status: 200,
          body: { message: "Webhook deleted" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "deletes a webhook" do
      response = webhooks.delete("1")

      expect(response["message"]).to eq("Webhook deleted")
    end
  end
end
