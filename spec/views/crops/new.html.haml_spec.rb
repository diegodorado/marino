require 'spec_helper'

describe "crops/new" do
  before(:each) do
    assign(:crop, stub_model(Crop).as_new_record)
  end

  it "renders new crop form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => crops_path, :method => "post" do
    end
  end
end
