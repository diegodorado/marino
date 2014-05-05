require 'spec_helper'

describe "admin/companies/edit" do
  before(:each) do
    @admin_company = assign(:admin_company, stub_model(Admin::Company))
  end

  it "renders the edit admin_company form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_companies_path(@admin_company), :method => "post" do
    end
  end
end
