class CompaniesController < ApplicationController
  load_and_authorize_resource  :find_by => :slug

  before_filter :require_company!, :except => [:index, :select]

  helper_method :current_company
  def current_company
    Company.find(session[:company_id]) rescue nil
  end

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

  
 
  private
 
  def require_company!
    unless current_company
      redirect_to companies_path, notice: "Debes seleccionar una empresa para comenzar."
    end
  end

end
