class StoresController < ApplicationController
  load_and_authorize_resource

  before_filter :require_company!
  
  def index
    @stores = current_company.stores
  end

  def create
    @store.company = current_company
    respond_to do |format|
      if @store.save
        format.html { redirect_to stores_path, notice: 'Store was successfully created.' }
        format.json { render json: @store, status: :created, location: @store }
      else
        format.html { render action: "new" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @store.company = current_company

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to stores_path, notice: 'Store was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    respond_to do |format|
      if @store.destroy
        format.html { redirect_to stores_path, notice: 'Se elimino el deposito.' }
        format.json { render json: '', status: :ok }
      else
        format.html { redirect_to stores_path, notice: 'Could not delete store.' }
        format.json { render json: '', status: :unprocessable_entity }
      end
    end

  end

end
