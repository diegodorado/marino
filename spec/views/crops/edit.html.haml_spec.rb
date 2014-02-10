require 'spec_helper'

describe "crops/edit" do
  before(:each) do
    @crop = assign(:crop, stub_model(Crop,
      :name => "MyString"
    ))
  end

  it "renders the edit crop form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => crops_path(@crop), :method => "post" do
      assert_select "input#crop_name", :name => "crop[name]"
    end
  end
end
