require 'spec_helper'

describe "admin/companies/new" do
  before(:each) do
    assign(:admin_company, stub_model(Admin::Company).as_new_record)
  end

  it "renders new admin_company form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_companies_path, :method => "post" do
    end
  end
end
