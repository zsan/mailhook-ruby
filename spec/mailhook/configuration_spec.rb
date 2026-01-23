# frozen_string_literal: true

RSpec.describe Mailhook::Configuration do
  subject(:config) { described_class.new }

  describe "defaults" do
    it "has default base_url" do
      expect(config.base_url).to eq("https://app.mailhook.co/api/v1")
    end

    it "has default timeout" do
      expect(config.timeout).to eq(30)
    end

    it "has default open_timeout" do
      expect(config.open_timeout).to eq(10)
    end

    it "has default max_retries" do
      expect(config.max_retries).to eq(2)
    end

    it "has default retry_statuses" do
      expect(config.retry_statuses).to eq([429, 500, 502, 503, 504])
    end

    it "has nil agent_id" do
      expect(config.agent_id).to be_nil
    end

    it "has nil api_key" do
      expect(config.api_key).to be_nil
    end
  end

  describe "#credentials?" do
    it "returns false when agent_id is nil" do
      config.api_key = "test_key"
      expect(config.credentials?).to be(false)
    end

    it "returns false when api_key is nil" do
      config.agent_id = "test_agent"
      expect(config.credentials?).to be(false)
    end

    it "returns false when agent_id is empty" do
      config.agent_id = ""
      config.api_key = "test_key"
      expect(config.credentials?).to be(false)
    end

    it "returns false when api_key is empty" do
      config.agent_id = "test_agent"
      config.api_key = ""
      expect(config.credentials?).to be(false)
    end

    it "returns true when both are set" do
      config.agent_id = "test_agent"
      config.api_key = "test_key"
      expect(config.credentials?).to be(true)
    end
  end

  describe "#reset!" do
    before do
      config.agent_id = "test_agent"
      config.api_key = "test_key"
      config.base_url = "https://custom.url"
      config.timeout = 60
    end

    it "resets all values to defaults" do
      config.reset!

      expect(config.agent_id).to be_nil
      expect(config.api_key).to be_nil
      expect(config.base_url).to eq("https://app.mailhook.co/api/v1")
      expect(config.timeout).to eq(30)
    end
  end
end
