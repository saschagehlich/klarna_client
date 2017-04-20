module FrontendDriver
  def go_home
    visit '/'
  end

  def crate_session
    within "#collapse2" do
      expect(first("#session_id").text).to eq("")

      click_button "Destroy Session"
      wait_for_ajax

      click_button "New Session"
      wait_for_ajax

      expect(first("#session_id").text).to_not eq("")

      click_button "Continue"
    end
  end

  def update_address(email='john@example.com')
    within "#collapse1" do
      expect(page).to have_text("Billing address", count: 1)

      fill_in('billing_address[email]', :with => email)
      fill_in('shipping_address[email]', :with => email)
      sleep(1)
      click_button "Continue"
    end
  end

  def select_credit
    if has_selector?("iframe#klarna-credit-fullscreen", wait: 5)
      within_frame("klarna-credit-fullscreen") do
        click_button "Continue"
      end
      wait_for_ajax
      sleep(1)
    end

    expect(page.first("iframe")).to be_visible

    within_frame("klarna-credit-main") do
      first('label', minimum: 1).click
    end

    wait_for_ajax
    sleep(1)

    within "#collapse3" do
      click_button "Authorize"
      wait_for_ajax
      sleep(1)
    end
  end

  def authorize_credit
    within "#collapse4" do
      expect(page).to have_text("Success: true")
    end
  end

  def find_order_id
    expect(order_id = find("#order_id").text).to_not be_empty
    order_id
  end

  def is_fraud?(status='ACCEPTED')
    expect(page).to have_text("Fraud status: #{status}")
  end
end
