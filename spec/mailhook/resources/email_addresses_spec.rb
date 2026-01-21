# frozen_string_literal: true

RSpec.describe Mailhook::Resources::EmailAddresses do
  let(:client) { Mailhook::Client.new(agent_id: "test_agent", api_key: "test_key") }
  let(:email_addresses) { client.email_addresses }

  describe "#create" do
    before do
      stub_request(:post, "https://api.mailhook.dev/api/v1/email_addresses")
        .with(body: { domain_id: "5", local_part: "support" }.to_json)
        .to_return(
          status: 201,
          body: { id: "1", address: "support@example.tail.me" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "creates an email address" do
      response = email_addresses.create(domain_id: "5", local_part: "support")

      expect(response["id"]).to eq("1")
      expect(response["address"]).to eq("support@example.tail.me")
    end
  end

  describe "#create_random" do
    before do
      stub_request(:post, "https://api.mailhook.dev/api/v1/email_addresses/random")
        .with(body: { domain_id: "5" }.to_json)
        .to_return(
          status: 201,
          body: { id: "2", address: "abc123@example.tail.me" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "creates a random email address" do
      response = email_addresses.create_random(domain_id: "5")

      expect(response["id"]).to eq("2")
      expect(response["address"]).to match(/@example\.tail\.me$/)
    end
  end

  describe "#list" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/email_addresses")
        .to_return(
          status: 200,
          body: { data: [{ id: "1", address: "test@example.tail.me" }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "lists email addresses" do
      response = email_addresses.list

      expect(response.count).to eq(1)
      expect(response.first["address"]).to eq("test@example.tail.me")
    end
  end

  describe "#retrieve" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/email_addresses/1")
        .to_return(
          status: 200,
          body: { id: "1", address: "test@example.tail.me" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "retrieves an email address" do
      response = email_addresses.retrieve("1")

      expect(response["id"]).to eq("1")
    end
  end

  describe "#delete" do
    before do
      stub_request(:delete, "https://api.mailhook.dev/api/v1/email_addresses/1")
        .to_return(
          status: 200,
          body: { message: "Email address deleted" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "deletes an email address" do
      response = email_addresses.delete("1")

      expect(response["message"]).to eq("Email address deleted")
    end
  end

  describe "#batch_create" do
    before do
      stub_request(:post, "https://api.mailhook.dev/api/v1/email_addresses/batch")
        .with(body: { email_addresses: [{ domain_id: "5", local_part: "test1" }] }.to_json)
        .to_return(
          status: 201,
          body: { data: [{ id: "1", address: "test1@example.tail.me" }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "batch creates email addresses" do
      response = email_addresses.batch_create([{ domain_id: "5", local_part: "test1" }])

      expect(response.count).to eq(1)
    end
  end
end
