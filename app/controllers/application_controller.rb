class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  def require_company!
    unless current_company
      redirect_to companies_path, notice: "Debes seleccionar una empresa para comenzar."
    end
  end
  
  helper_method :current_company
  def current_company
    Company.find(session[:company_id]) rescue nil
  end

end
