class CompaniesController < ApplicationController
  load_and_authorize_resource

  before_filter :require_company!, :except => [:index]

  respond_to :html, :json

  def stores
  end

  def marketing_costs
  end

end
