require "spec_helper"

RSpec.feature "Acknowledge an Order", :type => :feature, js: true do
  include FrontendDriver

  scenario "acknowledge an order" do
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

      Klarna.client.acknowledge(order_id).tap do |response|
        expect(response).to be_success
      end

      Klarna.client.get(order_id).tap do |order|
        expect(order).to be_success
        expect(order.body['status']).to eq("AUTHORIZED")
      end
    end
  end
end
