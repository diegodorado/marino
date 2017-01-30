class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  #show companies on homepage
  load_resource :company, :parent => false

  def index
    @companies = @companies.order_by(:name=>:asc)
  end

  def select_company
    session[:company_id] = @company.id
    return_to = session.delete(:return_to) || root_path
    redirect_to return_to , notice: "Seleccionaste la empresa #{@company.name}."
  end

end
