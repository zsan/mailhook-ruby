# frozen_string_literal: true

RSpec.describe Mailhook::Error do
  let(:response) do
    instance_double(
      Faraday::Response,
      status: 500,
      body: '{"error": "Something went wrong"}',
      headers: {}
    )
  end

  describe "#initialize" do
    it "accepts a message" do
      error = described_class.new("Custom message")
      expect(error.message).to eq("Custom message")
    end

    it "extracts error from response body" do
      error = described_class.new(response: response)
      expect(error.message).to eq("Something went wrong")
    end

    it "stores the response" do
      error = described_class.new(response: response)
      expect(error.response).to eq(response)
    end

    it "stores the status" do
      error = described_class.new(response: response)
      expect(error.status).to eq(500)
    end

    it "parses the body" do
      error = described_class.new(response: response)
      expect(error.body).to eq({ "error" => "Something went wrong" })
    end
  end
end

RSpec.describe Mailhook::AuthenticationError do
  it "has a default message" do
    error = described_class.new
    expect(error.message).to eq("Invalid or missing API credentials")
  end
end

RSpec.describe Mailhook::NotFoundError do
  it "has a default message" do
    error = described_class.new
    expect(error.message).to eq("The requested resource was not found")
  end
end

RSpec.describe Mailhook::RateLimitError do
  let(:response) do
    instance_double(
      Faraday::Response,
      status: 429,
      body: '{"error": "Rate limit exceeded"}',
      headers: { "retry-after" => "30" }
    )
  end

  it "extracts retry_after from headers" do
    error = described_class.new(response: response)
    expect(error.retry_after).to eq(30)
  end

  it "includes retry_after in message" do
    error = described_class.new(response: response)
    expect(error.message).to include("Retry after 30 seconds")
  end
end

RSpec.describe Mailhook::UnprocessableEntityError do
  let(:response) do
    instance_double(
      Faraday::Response,
      status: 422,
      body: '{"error": "Validation failed", "errors": {"email": ["is invalid"]}}',
      headers: {}
    )
  end

  it "extracts validation errors" do
    error = described_class.new(response: response)
    expect(error.errors).to eq({ "email" => ["is invalid"] })
  end
end

RSpec.describe Mailhook::BadRequestError do
  it "has a default message" do
    error = described_class.new
    expect(error.message).to eq("The request was invalid")
  end
end

RSpec.describe Mailhook::ForbiddenError do
  it "has a default message" do
    error = described_class.new
    expect(error.message).to eq("Access to this resource is forbidden")
  end
end

RSpec.describe Mailhook::ServerError do
  it "has a default message" do
    error = described_class.new
    expect(error.message).to eq("An internal server error occurred")
  end
end

RSpec.describe Mailhook::ConnectionError do
  it "has a default message" do
    error = described_class.new
    expect(error.message).to eq("Failed to connect to the Mailhook API")
  end
end

RSpec.describe Mailhook::TimeoutError do
  it "has a default message" do
    error = described_class.new
    expect(error.message).to eq("The request timed out")
  end
end
