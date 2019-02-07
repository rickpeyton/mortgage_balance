RSpec.describe Mortgage::Service do
  describe ".fetch" do
    it "returns the current mortgage balance" do
      allow(described_class).to receive(:loan).and_return(200000.0)
      stub_request(:post, "#{ENV["HOST"]}/accounts/balance/get").
        with(
          body: request_body_stub,
          headers: { "Content-Type" => "application/json; charset=utf-8" }
        ).
        to_return(status: 200, body: response_stub, headers: { "Content-Type" => "application/json" })

      result = described_class.fetch

      expect(result).to eq({
        balance: 101000.01,
        loan: 200000.00,
        paid: 98999.99,
        progress: 0.495
      })
    end
  end
end

def request_body_stub
  {
    "client_id": ENV["CLIENT_ID"],
    "secret": ENV["SECRET"],
    "access_token": ENV["ACCESS_TOKEN"]
  }.to_json
end

def response_stub
  {
    "accounts": [
      {
        "account_id": "some-account-id",
        "balances": {
          "available": 101000.01,
          "current": 101000.01,
          "iso_currency_code": "USD",
          "limit": nil,
          "unofficial_currency_code": nil
        },
        "mask": "0123",
        "name": "XXXXXX0123",
        "official_name": "Other Assets",
        "subtype": "other",
        "type": "other"
      }
    ],
    "item": {
      "available_products": [
        "balance"
      ],
      "billed_products": [
        "transactions"
      ],
      "error": nil,
      "institution_id": "ins_123456",
      "item_id": "some-item",
      "webhook": ""
    },
    "request_id": "some-request"
  }.to_json
end