module ControllerHelpers  

  def login
    Capybara.reset_sessions!
    user = FactoryGirl.create(:user, :password => 'secret')
    #request.session[:user] = user.id
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => 'secret'
    click_button "Entrar"
  end


  def logout
    visit destroy_user_session_path
  end


  def current_user
    User.find(request.session[:user])
  end  

    
end  
