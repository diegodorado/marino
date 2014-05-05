class Admin::CropsController < ApplicationController

  load_and_authorize_resource

  respond_to :json

  def index
  end

  def show
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
    if @crop.destroy
      render json: '', status: :ok
    else
      render json: '', status: :unprocessable_entity
    end
  end

  def update_prices

    if @crop.update_price(params[:month], params[:price], current_user)
      render json: @crop #head :no_content
    else
      render json: @crop.errors, status: :unprocessable_entity
    end

  end


  def get_price
    @crop = Crop.find(params[:crop_id])
    @crop.update_price(params[:month], '22.8', current_user)

    render json: @crop.get_price(params[:month])
  end




end
