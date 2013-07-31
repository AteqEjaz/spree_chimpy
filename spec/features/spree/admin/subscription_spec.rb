require 'spec_helper'

feature "Chimpy Admin", js: true do

  stub_authorization!
  let(:user) { create(:user)}
  background do
    visit spree.admin_path
  end
  scenario "New user subscription with subscription checked" do

    click_link "Users"
    click_link "New User"
    fill_in('user_email', :with => "#{user.email}1")
    fill_in('user_password', :with => 'test123456')
    fill_in('user_password_confirmation', :with => 'test123456')
    page.should have_content " SUBSCRIBED TO NEWSLETTER"
    check('user_subscribed')
    click_button('Create')

    #Failure/Error: Unable to find matching line from backtrace
    #ActiveRecord::StatementInvalid:
    #SQLite3::BusyException: database is locked: DELETE FROM sqlite_sequence where name = 'spree_assets';

    sleep (1)
    current_path.should == "/admin/users"
    page.should have_content "API ACCESS"
    page.should have_content "NO KEY"
    find_button('Generate API key').click
    fill_in('user_email', :with => "#{user.email}1")
    fill_in('user_password', :with => 'test123456')
    fill_in('user_password_confirmation', :with => 'test123456')
    page.should have_content " SUBSCRIBED TO NEWSLETTER"
    check('user_subscribed')
    click_button('Update')
    sleep (1)
    Spree::User.last.subscribed.should eql(true)
  end

  scenario "New user subscription with subscription un-checked" do

    click_link "Users"
    click_link "New User"
    fill_in('user_email', :with => "#{user.email}1")
    fill_in('user_password', :with => 'test123456')
    fill_in('user_password_confirmation', :with => 'test123456')
    page.should have_content " SUBSCRIBED TO NEWSLETTER"
    click_button('Create')

    #Failure/Error: Unable to find matching line from backtrace
    #ActiveRecord::StatementInvalid:
    #SQLite3::BusyException: database is locked: DELETE FROM sqlite_sequence where name = 'spree_assets';

    sleep (1)
    current_path.should == "/admin/users"
    page.should have_content "API ACCESS"
    page.should have_content "NO KEY"
    find_button('Generate API key').click
    fill_in('user_email', :with => "#{user.email}1")
    fill_in('user_password', :with => 'test123456')
    fill_in('user_password_confirmation', :with => 'test123456')
    page.should have_content " SUBSCRIBED TO NEWSLETTER"
    click_button('Update')
    sleep (1)
    Spree::User.last.subscribed.should eql(false)
  end
end
