require 'spec_helper'

module Klarna
  describe Configuration do
    context "production environment"  do
      before :each do
        Klarna.configure do |config|
          config.country = :eu
          config.environment = :production
        end
      end

      it "returns default environment is production" do
        expect(Klarna.configuration.environment).to eq(:production)
      end

      it "returns the production endpoint for eu" do
        expect(Klarna.configuration.endpoint).to eq('https://api.klarna.com')
      end

      it "returns the production endpoint for us" do
        Klarna.configure do |config|
          config.country = :us
        end
        expect(Klarna.configuration.endpoint).to eq('https://api-na.klarna.com')
      end
    end

    context "test environment" do
      before :each do
        Klarna.configure do |config|
          config.country = :eu
          config.environment = :test
        end
      end

      it "returns the production endpoint for eu" do
        expect(Klarna.configuration.endpoint).to eq('https://api.playground.klarna.com')
      end

      it "returns the production endpoint for us" do
        Klarna.configure do |config|
          config.country = :us
        end
        expect(Klarna.configuration.endpoint).to eq('https://api-na.playground.klarna.com')
      end
    end
  end
end
