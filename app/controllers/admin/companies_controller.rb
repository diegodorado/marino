class Admin::CompaniesController < ApplicationController
  load_and_authorize_resource


  # POST /admin/companies
  # POST /admin/companies.json
  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_companies_path, notice: 'Company was successfully created.' }
        format.json { render json: @company, status: :created, location: @company }
      else
        format.html { render action: "new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/companies/1
  # PUT /admin/companies/1.json
  def update
    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to admin_companies_path, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    respond_to do |format|
      if @company.destroy
        format.html { redirect_to admin_companies_path, notice: 'Se elimino la empresa.' }
        format.json { render json: '', status: :ok }
      else
        format.html { redirect_to admin_companies_path, notice: 'Could not delete store.' }
        format.json { render json: '', status: :unprocessable_entity }
      end
    end

  end


end
