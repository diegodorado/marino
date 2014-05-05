require "spec_helper"

describe Admin::CompaniesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/companies").should route_to("admin/companies#index")
    end

    it "routes to #new" do
      get("/admin/companies/new").should route_to("admin/companies#new")
    end

    it "routes to #show" do
      get("/admin/companies/1").should route_to("admin/companies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/companies/1/edit").should route_to("admin/companies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/companies").should route_to("admin/companies#create")
    end

    it "routes to #update" do
      put("/admin/companies/1").should route_to("admin/companies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/companies/1").should route_to("admin/companies#destroy", :id => "1")
    end

  end
end
