# frozen_string_literal: true

RSpec.describe Mailhook::Resources::InboundEmails do
  let(:client) { Mailhook::Client.new(agent_id: "test_agent", api_key: "test_key") }
  let(:inbound_emails) { client.inbound_emails }

  describe "#list" do
    before do
      stub_request(:get, "https://app.mailhook.co/api/v1/email_addresses/ea_123/inbound_emails")
        .to_return(
          status: 200,
          body: {
            data: [
              { id: "1", from: "sender@example.com", subject: "Test Email" }
            ]
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "lists inbound emails for an email address" do
      response = inbound_emails.list(email_address_id: "ea_123")

      expect(response.count).to eq(1)
      expect(response.first["subject"]).to eq("Test Email")
    end
  end

  describe "#list with unread filter" do
    before do
      stub_request(:get, "https://app.mailhook.co/api/v1/email_addresses/ea_123/inbound_emails")
        .with(query: { unread: "true" })
        .to_return(
          status: 200,
          body: { data: [] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "filters by unread status" do
      response = inbound_emails.list(email_address_id: "ea_123", unread: true)

      expect(response.count).to eq(0)
    end
  end

  describe "#retrieve" do
    before do
      stub_request(:get, "https://app.mailhook.co/api/v1/inbound_emails/1")
        .to_return(
          status: 200,
          body: {
            id: "1",
            from: "sender@example.com",
            subject: "Test Email",
            body: "Email body content"
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "retrieves an inbound email" do
      response = inbound_emails.retrieve("1")

      expect(response["id"]).to eq("1")
      expect(response["body"]).to eq("Email body content")
    end
  end

  describe "#mark_read" do
    before do
      stub_request(:patch, "https://app.mailhook.co/api/v1/inbound_emails/1/read")
        .to_return(
          status: 200,
          body: { id: "1", read: true }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "marks an email as read" do
      response = inbound_emails.mark_read("1")

      expect(response["read"]).to be(true)
    end
  end

  describe "#batch_mark_read" do
    before do
      stub_request(:patch, "https://app.mailhook.co/api/v1/inbound_emails/batch/read")
        .with(body: { ids: %w[1 2 3] }.to_json)
        .to_return(
          status: 200,
          body: { updated: 3 }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "batch marks emails as read" do
      response = inbound_emails.batch_mark_read(%w[1 2 3])

      expect(response["updated"]).to eq(3)
    end
  end

  describe "error handling" do
    before do
      stub_request(:get, "https://app.mailhook.co/api/v1/inbound_emails/999")
        .to_return(
          status: 404,
          body: { error: "Email not found" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "raises NotFoundError for 404" do
      expect { inbound_emails.retrieve("999") }.to raise_error(Mailhook::NotFoundError)
    end
  end
end
