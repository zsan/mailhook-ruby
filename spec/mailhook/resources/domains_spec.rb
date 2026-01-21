# frozen_string_literal: true

RSpec.describe Mailhook::Resources::Domains do
  let(:client) { Mailhook::Client.new(agent_id: "test_agent", api_key: "test_key") }
  let(:domains) { client.domains }

  describe "#create" do
    before do
      stub_request(:post, "https://api.mailhook.dev/api/v1/domains")
        .with(body: { slug: "mycompany" }.to_json)
        .to_return(
          status: 201,
          body: { id: "1", domain: "mycompany.tail.me", slug: "mycompany" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "creates a domain" do
      response = domains.create(slug: "mycompany")

      expect(response["id"]).to eq("1")
      expect(response["domain"]).to eq("mycompany.tail.me")
    end
  end

  describe "#list" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/domains")
        .to_return(
          status: 200,
          body: { data: [{ id: "1", domain: "test.tail.me" }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "lists all domains" do
      response = domains.list

      expect(response.count).to eq(1)
      expect(response.first["domain"]).to eq("test.tail.me")
    end
  end

  describe "#retrieve" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/domains/1")
        .to_return(
          status: 200,
          body: { id: "1", domain: "test.tail.me" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "retrieves a domain by ID" do
      response = domains.retrieve("1")

      expect(response["id"]).to eq("1")
      expect(response["domain"]).to eq("test.tail.me")
    end
  end

  describe "#delete" do
    before do
      stub_request(:delete, "https://api.mailhook.dev/api/v1/domains/1")
        .to_return(
          status: 200,
          body: { message: "Domain deleted" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "deletes a domain" do
      response = domains.delete("1")

      expect(response["message"]).to eq("Domain deleted")
    end
  end

  describe "#check_slug" do
    before do
      stub_request(:get, "https://api.mailhook.dev/api/v1/domains/check_slug")
        .with(query: { slug: "available" })
        .to_return(
          status: 200,
          body: { available: true }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "checks slug availability" do
      response = domains.check_slug("available")

      expect(response["available"]).to be(true)
    end
  end
end
