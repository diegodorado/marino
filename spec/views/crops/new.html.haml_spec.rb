require 'spec_helper'

describe "crops/new" do
  before(:each) do
    assign(:crop, stub_model(Crop,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new crop form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => crops_path, :method => "post" do
      assert_select "input#crop_name", :name => "crop[name]"
    end
  end
end
