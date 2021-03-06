require "spec_helper"

RSpec.feature "Refunding an Order", :type => :feature, js: true do
  include FrontendDriver

  scenario "refunds captured amount" do
    go_home()

    update_address()

    crate_session()

    select_credit()

    authorize_credit()

    find_order_id.tap do |order_id|
      Klarna.client.get(order_id).tap do |order|
        expect(order).to be_success
        expect(order.body['status']).to eq("AUTHORIZED")
      end

      Klarna.client.capture(order_id, captured_amount: 10).tap do |response|
        expect(response).to be_success
      end
      sleep(2)

      Klarna.client(:refund).create(order_id, refunded_amount: 10).tap do |response|
        expect(response).to be_success
      end
      sleep(1)

      Klarna.client.get(order_id).tap do |order|
        expect(order).to be_success
        expect(order.body['refunds']).to_not be_empty
        expect(order.body['refunded_amount']).to_not eq(0)
        expect(order.body['status']).to eq("CAPTURED")
      end
    end
  end
end
