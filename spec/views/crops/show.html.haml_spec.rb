require 'spec_helper'

describe "crops/show" do
  before(:each) do
    @crop = assign(:crop, stub_model(Crop,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
