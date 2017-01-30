class Api::StoresController < ApplicationController
  load_and_authorize_resource
  before_filter :require_company!
  respond_to :json

  def index
    render json: current_company.stores
  end

  def create
    @store.company = current_company
    if @store.save
      render json: @store, status: :created, location: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end


  def update
    params[:store].inspect
    @store.update_attributes(params[:store])

    if @store.save
      render json: @store, status: :ok
    else
      render json: @store.errors, status: :unprocessable_entity
    end

  end

  def destroy
    begin
      if @store.destroy
        render json: '', status: :ok
      else
        render json: '', status: :unprocessable_entity
      end
    rescue
      render json: '', status: :error
    end

  end

end
