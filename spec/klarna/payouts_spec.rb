require 'spec_helper'

module Klarna
  describe Payouts do
    let(:payment_reference) { "ec071a6c-7af6-4528-9485-73eabaa003a3" }
    let(:from_date) { Time.now.utc }
    let(:to_date) { Time.now.utc }
    let(:payload) do
      {
        start_date: from_date.iso8601,
        end_date: to_date.iso8601
      }
    end

    before :each do
      if ENV["KLARNA_API_KEY"].nil? && ENV["KLARNA_API_SECRET"].nil?
        fail "KLARNA_API_KEY and KLARNA_API_SECRET environment variables not set"
      end

      Klarna.configure do |config|
        config.environment = :test
        config.country = ENV.fetch("KLARNA_REGION") { :eu }.to_sym
        config.api_key = ENV["KLARNA_API_KEY"]
        config.api_secret = ENV["KLARNA_API_SECRET"]
      end
    end

    it "retrieves a payout" do
      Klarna.client(:payouts).payout(payment_reference).tap do |response|
        expect(response).to be_success
        expect(response.body["payment_reference"]).to eq(payment_reference)
      end
    end

    it "retrieves a payout summary" do
      Klarna.client(:payouts).payout_summary(payload).tap do |response|
        expect(response).to be_success
        expect(response.body.respond_to?(:[])).to be_truthy
      end
    end
  end
end
