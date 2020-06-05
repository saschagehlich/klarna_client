require 'spec_helper'

module Klarna
  describe Payouts do
    let(:payment_reference) { "2f2ad480-d3c4-4dae-9ca6-9df8af8d7311" }
    let(:from_date) { Date.parse("2019-05-01") }
    let(:to_date) { Date.parse("2019-06-01") }
    let(:payload) { { start_date: from_date.iso8601, end_date: to_date.iso8601 } }
    let(:size) { 5 }
    let(:offset) { 1 }

    before :all do
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

    describe "#payout" do
      it "retrieves a payout" do
        Klarna.client(:payouts).payout(payment_reference).tap do |response|
          expect(response).to be_success
          expect(response.body["payment_reference"]).to eq(payment_reference)
        end
      end
    end

    describe "#payouts" do
      it "retrieves some payouts" do
        Klarna.client(:payouts).payouts(payload).tap do |response|
          expect(response).to be_success
          expect(response.body["payouts"]).to_not be_nil
        end
      end

      it "retrieves some paginated payouts" do
        payload_with_pagination = payload.merge(size: size, offset: offset)

        Klarna.client(:payouts).payouts(payload_with_pagination).tap do |response|
          expect(response).to be_success
          expect(response.body["payouts"]).to_not be_nil
          expect(response.body["payouts"].count).to eq(size)
          expect(response.body["pagination"]["count"]).to eq(size)
          expect(response.body["pagination"]["offset"]).to eq(offset)
        end
      end
    end

    describe "#payout_transactions" do
      let(:payload) { { payment_reference: payment_reference } }

      it "retrieves transactions for a payout" do
        Klarna.client(:payouts).payout_transactions(payload).tap do |response|
          expect(response).to be_success
          expect(response.body["transactions"]).to_not be_nil
          expect(response.body["transactions"].map { |t| t["payment_reference"] }.uniq).to eq [payment_reference]
        end
      end

      it "retrieves some paginated transactions for a payout" do
        payload_with_pagination = payload.merge(size: size, offset: offset)

        Klarna.client(:payouts).payout_transactions(payload_with_pagination).tap do |response|
          expect(response).to be_success
          expect(response.body["transactions"]).to_not be_nil
          expect(response.body["transactions"].map { |t| t["payment_reference"] }.uniq).to eq [payment_reference]
          expect(response.body["transactions"].count).to eq(size)
          expect(response.body["pagination"]["count"]).to eq(size)
          expect(response.body["pagination"]["offset"]).to eq(offset)
        end
      end
    end

    describe "#payout_summary" do
      it "retrieves a payout summary" do
        Klarna.client(:payouts).payout_summary(payload).tap do |response|
          expect(response).to be_success
          expect(response.body.respond_to?(:[])).to be_truthy
        end
      end
    end
  end
end
