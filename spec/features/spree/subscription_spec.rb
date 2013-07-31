require 'spec_helper'

feature "Chimpy", js: true do
  stub_authorization!
  background do
    visit '/signup'
  end
  scenario "Guest Subscription deface data-hook Confirmation" do
    visit '/checkout/registration'
    page.find("#footer-right")
  end
    xscenario "user subscription with Opt_in" do
     # "This is pending due to wrong behaviour of user subscription"
    fill_in('spree_user_email', :with => 'ryan@spree.com')
    fill_in('spree_user_password', :with => 'test123456')
    fill_in('spree_user_password_confirmation', :with => 'test123456')
    check('spree_user_subscribed')
    page.should have_content "Sign me up to the newsletter"
    click_button('Create')

    #Failure/Error: Unable to find matching line from backtrace
    #ActiveRecord::StatementInvalid:
    #SQLite3::BusyException: database is locked: DELETE FROM "spree_chimpy_order_sources";so we will need to use sleep function.

    sleep (1)
    current_path.should == "/"
    page.should have_selector ".notice", text: "Welcome! You have signed up successfully."
    Spree::User.first.subscribed.should eql(true)
  end
  scenario "user subscription with Opt_out" do

    fill_in('spree_user_email', :with => 'ryan@spree.com')
    fill_in('spree_user_password', :with => 'test123456')
    fill_in('spree_user_password_confirmation', :with => 'test123456')
    uncheck('spree_user_subscribed')
    page.should have_content "Sign me up to the newsletter"
    click_button('Create')

    #Failure/Error: Unable to find matching line from backtrace
    #ActiveRecord::StatementInvalid:
    #SQLite3::BusyException: database is locked: DELETE FROM "spree_chimpy_order_sources";so we will need to use sleep function.

    sleep (1)
    current_path.should == "/"
    page.should have_selector ".notice", text: "Welcome! You have signed up successfully."
    Spree::User.first.subscribed.should eql(false)
  end
end
