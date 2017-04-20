require "spec_helper"

RSpec.feature "Creates an Order", :type => :feature, js: true do
  include FrontendDriver

  scenario "creates an ACCEPTED && AUTHORIZED order" do
    go_home()

    update_address()

    crate_session()

    select_credit()

    authorize_credit()

    is_fraud?('ACCEPTED')

    find_order_id.tap do |order_id|
      Klarna.client.get(order_id).tap do |order|
        expect(order.order_id).to_not be_falsy
        expect(order).to be_success
        expect(order.body['status']).to eq("AUTHORIZED")
        expect(order.body['fraud_status']).to eq("ACCEPTED")
      end
    end
  end

  scenario "creates a PENDING && AUTHORIZED order" do
    go_home()

    update_address('joe+pend-reject-60@example.com')

    crate_session()

    select_credit()

    authorize_credit()

    is_fraud?('PENDING')

    find_order_id.tap do |order_id|
      Klarna.client.get(order_id).tap do |order|
        expect(order.order_id).to_not be_falsy
        expect(order).to be_success
        expect(order.body['status']).to eq("AUTHORIZED")
        expect(order.body['fraud_status']).to eq("PENDING")
      end
    end
  end

  scenario "shows no options for this user " do
    go_home()

    update_address('joe+red@example.com')

    crate_session()

    sleep(3)

    within_frame("klarna-credit-main") do
      expect(page).to have_text("Option not available")
    end
  end
end
