module Klarna
  class Payouts < Client
    def payout(payment_reference)
      do_request(:post, "/settlements/v1/payouts/#{payment_reference}")
    end

    def payout_summary(data)
      do_request :get, "/settlements/v1/payouts/summary" do |request|
        request.body = data.to_json
      end
    end
  end
end
