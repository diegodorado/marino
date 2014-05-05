class CompaniesController < ApplicationController
  load_and_authorize_resource  :find_by => :slug

  before_filter :require_company!, :except => [:index, :select]

  respond_to :html, :json


  def select
    session[:company_id] = @company.id
    redirect_to summary_crop_controls_path, notice: "Seleccionaste una empresa."
  end

  def comment
    @comment = @company.create_comment! :author => current_user, :text => params[:text]
    return render :json => @comment.to_json
  end

end
