# frozen_string_literal: true

RSpec.describe Mailhook::Resources::OutboundEmails do
  let(:client) { Mailhook::Client.new(agent_id: "test_agent", api_key: "test_key") }
  let(:outbound_emails) { client.outbound_emails }

  describe "#send" do
    before do
      stub_request(:post, "https://api.mailhook.dev/api/v1/outbound_emails")
        .with(body: {
          from_email_address_id: "123",
          to: "recipient@example.com",
          subject: "Hello",
          body: "Test message"
        }.to_json)
        .to_return(
          status: 201,
          body: { id: "1", status: "queued" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "sends an email" do
      response = outbound_emails.send(
        from_email_address_id: "123",
        to: "recipient@example.com",
        subject: "Hello",
        body: "Test message"
      )

      expect(response["id"]).to eq("1")
      expect(response["status"]).to eq("queued")
    end
  end

  describe "#send with html_body" do
    before do
      stub_request(:post, "https://api.mailhook.dev/api/v1/outbound_emails")
        .with(body: {
          from_email_address_id: "123",
          to: "recipient@example.com",
          subject: "Hello",
          body: "Text version",
          html_body: "<p>HTML version</p>"
        }.to_json)
        .to_return(
          status: 201,
          body: { id: "1", status: "queued" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "sends an email with HTML body" do
      response = outbound_emails.send(
        from_email_address_id: "123",
        to: "recipient@example.com",
        subject: "Hello",
        body: "Text version",
        html_body: "<p>HTML version</p>"
      )

      expect(response["status"]).to eq("queued")
    end
  end

  describe "#retrieve" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/outbound_emails/1")
        .to_return(
          status: 200,
          body: { id: "1", status: "delivered", to: "recipient@example.com" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "retrieves an outbound email" do
      response = outbound_emails.retrieve("1")

      expect(response["id"]).to eq("1")
      expect(response["status"]).to eq("delivered")
    end
  end

  describe "#list" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/outbound_emails")
        .to_return(
          status: 200,
          body: { data: [{ id: "1", status: "delivered" }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "lists outbound emails" do
      response = outbound_emails.list

      expect(response.count).to eq(1)
      expect(response.first["status"]).to eq("delivered")
    end
  end
end
