class Api::CropsController < ApplicationController

  load_and_authorize_resource
  respond_to :json

  def index
    respond_with @crops
  end

  def show
    respond_with @crop
  end

  def create
    @crop = Crop.new(params[:crop])

    if @crop.save
      render json: @crop, status: :created, location: @crop
    else
      render json: @crop.errors, status: :unprocessable_entity
    end

  end

  def update
    @crop.update_attributes(params[:crop])

    if @crop.save
      render json: @crop, status: :ok
    else
      render json: @crop.errors, status: :unprocessable_entity
    end

  end

  def destroy
    begin
      if @crop.destroy
        render json: @crop, status: :ok
      else
        render json: '', status: :unprocessable_entity
      end
    rescue
      render json: '', status: :error
    end
  end

end
