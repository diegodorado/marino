module ControllerMacros  
  def login
    user = FactoryGirl.build(:user, :password => 'secret')
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => 'secret'
    click_button "Entrar"
  end  
end  
