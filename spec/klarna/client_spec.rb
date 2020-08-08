require 'spec_helper'

module Klarna
  describe Client do
    after :each do
      Klarna.configure do |config|
        config.debugger = nil
      end
    end

    it "sets debbug mode by setting http debug output" do
      Klarna.configure do |config|
        config.debugger = $stdout
      end
      expect_any_instance_of(Net::HTTP).to receive(:set_debug_output).with($stdout).once
      expect_any_instance_of(Net::HTTP).to receive(:set_debug_output).with(nil).once
      expect_any_instance_of(Net::HTTP).to receive(:request).and_return(OpenStruct.new({code: 123, body: ""}))

      response = Klarna.client(:payments).create_session({})
    end

    it "unsets debbug mode by setting http debug output" do
      Klarna.configure do |config|
        config.debugger = nil
      end
      expect_any_instance_of(Net::HTTP).not_to receive(:set_debug_output)
      expect_any_instance_of(Net::HTTP).to receive(:request).and_return(OpenStruct.new({code: 123, body: ""}))

      response = Klarna.client(:payments).create_session({})
    end

    it "returns an Klarna::Error on failed http request" do
      Klarna.configure do |config|
        config.debugger = nil
        config.api_key = "wrong_key"
      end

      Klarna.client(:payments).create_session({}).tap do |response|
        expect(response).to be_error
        expect(response.code).to eq(401)
      end
    end
  end
end
