require 'spec_helper'

module Klarna
  describe Credit do
    let(:data) do
      {
        purchase_country: "US" ,
        purchase_currency: "USD" ,
        order_amount: "10",
        order_tax_amount: "1",
        order_lines: [
          {
            type: "physical",
            reference: "19­-402-­USA",
            name: "Battery Power Pack",
            quantity: "1",
            quantity_unit: "kg",
            unit_price: "10",
            tax_rate: "10",
            total_amount: "10",
            total_discount_amount: "0",
            total_tax_amount: "1",
            product_url: "https://www.estore.com/products/f2a8d7e34",
            image_url: "https://www.exampleobjects.com/logo.png"
          }
        ]
      }
    end

    before :each do
      if ENV["KLARNA_API_KEY"].nil? && ENV["KLARNA_API_SECRET"].nil?
        fail "KLARNA_API_KEY and KLARNA_API_SECRET environment variables not set"
      end

      Klarna.configure do |config|
        config.environment = :test
        config.country = ENV.fetch("KLARNA_REGION") { :us }.to_sym
        config.api_key = ENV["KLARNA_API_KEY"]
        config.api_secret = ENV["KLARNA_API_SECRET"]
      end
    end

    it "creates a session" do
      Klarna.client(:credit).create_session(data).tap do |response|
        expect(response).to be_success
        expect(response.session_id).to be_a(String)
        expect(response.client_token).to be_a(String)
      end
    end

    it "updates a session" do
      Klarna.client(:credit).create_session(data).tap do |response|
        Klarna.client(:credit).update_session(response.session_id, data).tap do |response|
          expect(response).to be_success
        end
      end
    end

    # it capture an order
    # Due to the frontend nature of credits this needs to be implamente in a feature test
    # check /spec/klarna/features/capture_order_spec.rb

    # it cancels an order
    # Due to the frontend nature of credits this needs to be implamente in a feature test
    # check /spec/klarna/features/cancel_order_spec.rb

    context "with invalid data" do
      let(:data) do
        {
          purchase_country: "US" ,
          purchase_currency: "INVALID_CURRENCY" ,
          order_amount: "-10",
          order_tax_amount: "1"
        }
      end

      it "returns a non-successful result" do
        Klarna.client(:credit).create_session(data).tap do |response|
          expect(response).to_not be_success
        end
      end
    end
  end
end
