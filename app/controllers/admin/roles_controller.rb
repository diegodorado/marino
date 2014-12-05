class Admin::RolesController < ApplicationController

  load_and_authorize_resource

  def index
    @role = Role.new
  end


  # POST /admin/companies
  # POST /admin/companies.json
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        format.html { redirect_to admin_roles_path, notice: 'Role was successfully created.' }
        format.json { render json: @role, status: :created, location: @role }
      else
        format.html { render action: "new" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/companies/1
  # PUT /admin/companies/1.json
  def update
    respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to admin_roles_path, notice: 'Role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    respond_to do |format|
      if @role.destroy
        format.html { redirect_to admin_roles_path, notice: 'Se elimino el rol.' }
        format.json { render json: '', status: :ok }
      else
        format.html { redirect_to admin_roles_path, notice: 'Could not delete store.' }
        format.json { render json: '', status: :unprocessable_entity }
      end
    end

  end

end
