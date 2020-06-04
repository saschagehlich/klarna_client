module Klarna
  class Payouts < Client
    def payout(payment_reference)
      do_request(:get, "/settlements/v1/payouts/#{payment_reference}")
    end

    def payout_summary(start_date:, end_date:)
      do_request :get, "/settlements/v1/payouts/summary?start_date=#{start_date}&end_date=#{end_date}"
    end
  end
end
