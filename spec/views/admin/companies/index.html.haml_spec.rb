require 'spec_helper'

describe "admin/companies/index" do
  before(:each) do
    assign(:admin_companies, [
      stub_model(Admin::Company),
      stub_model(Admin::Company)
    ])
  end

  it "renders a list of admin/companies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
