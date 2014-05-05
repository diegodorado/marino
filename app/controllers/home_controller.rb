class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  #show companies on homepage
  load_resource :company, :parent => false, :find_by => :slug

  def index
  end



  def select_company
    session[:company_id] = @company.id
    redirect_to summary_crop_controls_path, notice: "Seleccionaste una empresa."
  end

end
