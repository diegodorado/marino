class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  def require_company!
    unless current_company
      session[:return_to] = request.fullpath
      redirect_to root_path, notice: "Debes seleccionar una empresa para comenzar."
    end
    @company = current_company

  end

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  helper_method :current_company
  def current_company
    Company.find(session[:company_id]) rescue nil
  end

end
