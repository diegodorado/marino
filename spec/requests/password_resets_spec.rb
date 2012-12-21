# encoding: utf-8
require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = FactoryGirl.build(:user)
    visit new_user_session_path
    click_link "Olvidaste tu contraseña?"
    fill_in "user_email", :with => user.email
    #save_and_open_page
    click_button "Resetear"
    page.should have_content("You will receive an email with instructions")
  end  
end
