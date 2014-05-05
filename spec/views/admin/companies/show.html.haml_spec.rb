require 'spec_helper'

describe "admin/companies/show" do
  before(:each) do
    @admin_company = assign(:admin_company, stub_model(Admin::Company))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
