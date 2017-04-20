require "spec_helper"

RSpec.feature "Extending an Order", :type => :feature, js: true do
  include FrontendDriver

  scenario "extends an order" do
    go_home()

    update_address()

    crate_session()

    select_credit()

    authorize_credit()

    find_order_id.tap do |order_id|
      Klarna.client.extend(order_id).tap do |response|
        expect(response).to be_success
      end
    end
  end
end
