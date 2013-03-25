require 'spec_helper'

describe "stores/new" do
  before(:each) do
    assign(:store, stub_model(Store).as_new_record)
  end

  it "renders new store form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => stores_path, :method => "post" do
    end
  end
end
