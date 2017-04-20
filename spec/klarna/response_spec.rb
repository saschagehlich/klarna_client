require "spec_helper.rb"

module Klarna
  describe Response do
    let(:http_response) { double() }
    let(:code) { 200 }
    let(:body) { '{"order_amount": 10}' }

    before do
      @headers = { band: 'Red Hot Chili Peper'}
      allow(http_response).to receive_messages(code: code, body: body, content_type: 'application/json', to_hash: @headers )
    end

    subject(:response) { Klarna::Response.new(http_response) }

    context "with successful http call" do
      let(:code) { 200 }
      let(:body) { '{"order_amount": 10}' }

      it { is_expected.to be_success }
      it { is_expected.to_not be_error }
      it "it responds to top level objects of the response json" do
        expect(response.order_amount).to eq(10)
      end

      context "without message body" do
        let(:body) { '' }
        it { is_expected.to be_success }
      end
    end

    context "with unsuccessful http call" do
      let(:code) { 422 }
      let(:body) { '{"error_code": "BAD_REQUEST"}' }

      it { is_expected.to_not be_success }
      it { is_expected.to be_error }
      it "it responds to top level objects of the response json" do
        expect(response.error_code).to eq("BAD_REQUEST")
      end
    end

    context "explicit or implicit headers" do
      it "return an explicit hash of headers" do
        expect(response.headers).to eq(@headers)
      end

      it "responds to an implicit hash of headers" do
        expect(response.http_response).to receive(:[]).with('test').and_return("foo")
        expect(response['test']).to eq("foo")
      end
    end
  end
end
