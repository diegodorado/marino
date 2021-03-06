class Api::CropControlsController < ApplicationController
  load_and_authorize_resource
  respond_to :json
  before_filter :require_company!

  def summary
    @result = CropControl.summary(params[:balance_at], @company.stores.pluck(:_id))
    render json: @result
  end

  def index
    @result = CropControl.list(params[:store_id],params[:crop_id],params[:gestion].to_i==1)
    render json: @result
  end



  def create
    @crop_control = CropControl.new(crop_control_params)
    @crop_control.updater = current_user

    if @crop_control.save
      render json: @crop_control, status: :created, location: @crop_control
    else
      render json: @crop_control.errors, status: :unprocessable_entity
    end

  end

  def update
    @crop_control.update_attributes(crop_control_params)
    @crop_control.updater = current_user

    if @crop_control.save
      render json: @crop_control, status: :ok
    else
      render json: @crop_control.errors, status: :unprocessable_entity
    end

  end

  def destroy
    if @crop_control.destroy
      render json: '', status: :ok
    else
      render json: '', status: :unprocessable_entity
    end
  end

  private
  def crop_control_params
    params.require(:crop_control)
    params.permit(:store_id, :crop_id, :fecha ,:tipo_doc,:entrada,:salida,:precio_unitario,:comentario,:gestion,:contabilidad)
  end







end
