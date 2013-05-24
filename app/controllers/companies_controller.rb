class CompaniesController < ApplicationController
  load_and_authorize_resource  :find_by => :slug

  before_filter :require_company!, :except => [:index, :select]


  respond_to :html, :json

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
    @company_comments = @company.comments
  end

  def comment
    @comment = @company.create_comment! :author => current_user, :text => params[:text]
    return render :json => @comment.to_json
  end
 
  private
 
  def require_company!
    unless current_company
      redirect_to companies_path, notice: "Debes seleccionar una empresa para comenzar."
    end
  end

end
