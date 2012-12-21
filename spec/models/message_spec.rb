require 'spec_helper'

describe Message do
  describe "#send_password_reset" do
    let(:user) { FactoryGirl.build(:user) }
    
    it "creates a new message" do
      message = FactoryGirl.create(:message)
      message.creator  = user
      message.text.should include ("foo")
    end
    
    
  end
end
