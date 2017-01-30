class CompaniesController < ApplicationController
  load_and_authorize_resource

  before_filter :require_company!, :except => [:index, :select]

  respond_to :html, :json

  def select
    session[:company_id] = @company.id
    redirect_to summary_crop_controls_path, notice: "Seleccionaste una empresa."
  end

  def stores
  end

  def marketing_costs
  end

end
