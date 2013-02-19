require 'spec_helper'

describe "crops/index" do
  before(:each) do
    assign(:crops, [
      stub_model(Crop),
      stub_model(Crop)
    ])
  end

  it "renders a list of crops" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
