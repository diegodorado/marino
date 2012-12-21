require 'spec_helper'

describe "Messages" do
  describe "GET /messages" do

    include ControllerMacros

    before(:each) do  
      login
    end  

    it "should login the user" do
      user = FactoryGirl.create(:user, :password => 'secret')
      visit new_user_session_path
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => 'secret'
      click_button "Entrar"
      page.should have_content("Signed in successfully")
        
    end

    it "show messages listing" do
      login
      visit messages_path
      page.should have_content("Listing messages")
    end
  end
end
