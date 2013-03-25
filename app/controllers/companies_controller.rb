class CompaniesController < ApplicationController
  load_and_authorize_resource  :find_by => :slug
  skip_before_filter :require_company!, :only => [:index, :select]
  
  def index
  end

  def select
    session[:company_id] = @company.id
    
    @stores = @company.stores
    @crops = Crop.only(:_id,:name).all
    #todo: filter by company
    @crop_controls = CropControl.all
    #redirect_to companies_path, notice: "Seleccionaste #{@company.name}"
  end


end
