require 'spec_helper'

describe "Messages" do
  describe "GET /messages" do


    before(:each) do  
      login
    end  

    it "show messages listing" do
      visit messages_path
      page.should have_content("Listing messages")
    end
  end

  it "blocks unauthenticated access" do
    Capybara.reset_sessions!
    visit messages_path
    page.should have_content("not authorized")
  end

  it "allows authenticated access" do
    login
    
    visit messages_path
    
    current_path.should == messages_path
  end
  
end
