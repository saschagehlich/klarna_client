module Klarna
  class Token < Client
    def create_token(authorization_token, data)
      do_request :post, "/credit/v1/authorizations/#{authorization_token}/customer-token" do |request|
        request.body = data.to_json
      end
    end

    def create_order(customer_token, data) do |request|
      do_request :post, "/customer-token/v1/tokens/#{customer_token}/order" do |request|
        request.body = data.to_json
      end
    end
  end
end
