module Klarna
  class Payouts < Client
    PAYOUTS_PATH = "/settlements/v1/payouts".freeze
    TRANSACTIONS_PATH = "/settlements/v1/transactions".freeze

    def payout(payment_reference)
      do_request(:get, "#{PAYOUTS_PATH}/#{payment_reference}")
    end

    def payouts(data)
      path_with_params = [PAYOUTS_PATH, URI.encode_www_form(data)].join("?")
      do_request(:get, path_with_params)
    end

    def payout_transactions(data)
      path_with_params = [TRANSACTIONS_PATH, URI.encode_www_form(data)].join("?")
      do_request(:get, path_with_params)
    end

    def payout_summary(start_date:, end_date:)
      do_request(:get, "#{PAYOUTS_PATH}/summary?start_date=#{start_date}&end_date=#{end_date}")
    end
  end
end
