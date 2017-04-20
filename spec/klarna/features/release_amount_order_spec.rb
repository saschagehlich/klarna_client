require "spec_helper"

RSpec.feature "Release amount an Order", :type => :feature, js: true do
  include FrontendDriver

  scenario "Can not release remaining amount of an order without capture" do
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

      Klarna.client.release(order_id).tap do |response|
        expect(response).to be_error
        expect(response.error_code).to eq('NOT_ALLOWED')
      end
    end
  end

  scenario "Release remaining amount an order" do
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

      Klarna.client.capture(order_id, captured_amount: 5).tap do |response|
        expect(response).to be_success
      end

      Klarna.client.get(order_id).tap do |order|
        expect(order).to be_success
        expect(order.body['status']).to eq("PART_CAPTURED")
      end

      Klarna.client.release(order_id).tap do |response|
        expect(response).to be_success
      end

      Klarna.client.get(order_id).tap do |order|
        expect(order).to be_success
        expect(order.body['status']).to eq("CAPTURED")
      end
    end
  end
end
