# frozen_string_literal: true

RSpec.describe Mailhook::Response do
  describe "with hash data" do
    subject(:response) do
      described_class.new(
        data: { "id" => 1, "name" => "Test" },
        status: 200,
        headers: { "content-type" => "application/json" }
      )
    end

    describe "#[]" do
      it "accesses data by string key" do
        expect(response["id"]).to eq(1)
      end

      it "accesses data by symbol key" do
        expect(response[:name]).to eq("Test")
      end

      it "returns nil for missing keys" do
        expect(response["missing"]).to be_nil
      end
    end

    describe "#data" do
      it "returns the data hash" do
        expect(response.data).to eq({ "id" => 1, "name" => "Test" })
      end
    end

    describe "#status" do
      it "returns the HTTP status" do
        expect(response.status).to eq(200) # rubocop:disable RSpecRails/HaveHttpStatus
      end
    end

    describe "#success?" do
      it "returns true for 2xx status" do
        expect(response.success?).to be(true)
      end

      it "returns false for non-2xx status" do
        error_response = described_class.new(data: {}, status: 404, headers: {})
        expect(error_response.success?).to be(false)
      end
    end

    describe "#to_h" do
      it "returns the data as hash" do
        expect(response.to_h).to eq({ "id" => 1, "name" => "Test" })
      end
    end

    describe "#key?" do
      it "returns true for existing keys" do
        expect(response.key?("id")).to be(true)
        expect(response.key?(:name)).to be(true)
      end

      it "returns false for missing keys" do
        expect(response.key?("missing")).to be(false)
      end
    end

    describe "#keys" do
      it "returns all keys" do
        expect(response.keys).to contain_exactly("id", "name")
      end
    end
  end

  describe "with wrapped data" do
    subject(:response) do
      described_class.new(
        data: { "data" => [{ "id" => 1 }, { "id" => 2 }], "meta" => { "total" => 2 } },
        status: 200,
        headers: {}
      )
    end

    describe "#data" do
      it "extracts data from wrapper" do
        expect(response.data).to eq([{ "id" => 1 }, { "id" => 2 }])
      end
    end

    describe "#meta" do
      it "extracts meta from wrapper" do
        expect(response.meta).to eq({ "total" => 2 })
      end
    end
  end

  describe "with array data" do
    subject(:response) do
      described_class.new(
        data: { "data" => [{ "id" => 1 }, { "id" => 2 }] },
        status: 200,
        headers: {}
      )
    end

    describe "#each" do
      it "iterates over items" do
        ids = response.map { |item| item["id"] }
        expect(ids).to eq([1, 2])
      end

      it "returns an enumerator without block" do
        expect(response.each).to be_an(Enumerator)
      end
    end

    describe "#first" do
      it "returns the first item" do
        expect(response.first).to eq({ "id" => 1 })
      end
    end

    describe "#last" do
      it "returns the last item" do
        expect(response.last).to eq({ "id" => 2 })
      end
    end

    describe "#count" do
      it "returns the number of items" do
        expect(response.count).to eq(2)
      end
    end

    describe "#empty?" do
      it "returns false when data exists" do
        expect(response.empty?).to be(false)
      end

      it "returns true when data is empty" do
        empty_response = described_class.new(data: { "data" => [] }, status: 200, headers: {})
        expect(empty_response.empty?).to be(true)
      end
    end
  end
end
