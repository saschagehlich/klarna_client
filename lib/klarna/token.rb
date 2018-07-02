module Klarna
  class Token < Client
    def create_order(customer_token, data)
      do_request :post, "/customer-token/v1/tokens/#{customer_token}/order" do |request|
        request.body = data.to_json
      end
    end
  end
end
