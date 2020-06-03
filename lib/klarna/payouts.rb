module Klarna
  class Payouts < Client
    def payout(payment_reference)
      do_request(:get, "/settlements/v1/payouts/#{payment_reference}")
    end

    def payout_summary(data)
      do_request :get, "/settlements/v1/payouts/summary?start_date=#{data[:start_date]}&end_date=#{data[:end_date]}"
    end
  end
end
