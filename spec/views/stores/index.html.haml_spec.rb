require 'spec_helper'

describe "stores/index" do
  before(:each) do
    assign(:stores, [
      stub_model(Store),
      stub_model(Store)
    ])
  end

  it "renders a list of stores" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
