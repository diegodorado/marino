class CropControlsController < ApplicationController

  load_and_authorize_resource

  respond_to :json

  before_filter :require_company!
  before_filter :set_valid_params , :except => [:index,:list, :summary, :destroy]

  def set_valid_params
    valid_params = [
      :fecha,
      :crop_id,
      :store_id,
      :entrada,
      :salida,
      :precio_unitario,
      :gestion,
      :contabilidad,
      :tipo_doc,
      :comentario
    ]
    #logger.debug params
    crop_control = params[:crop_control]
    crop_control.keep_if {| key, value | valid_params.include?(key.to_sym) }
    params[:crop_control] = crop_control
  end

  def summary
    @company = current_company
    stores = @company.stores
    @crops = Crop.only(:_id,:name).all            
    @crop_controls = CropControl.in(store_id: stores.pluck(:_id))
    respond_to do |format|
      format.html
    end
  end

  def list
    @company = current_company
    @stores = @company.stores
    @crops = Crop.only(:_id,:name).all
    #todo: filter by company
    @crop_controls = CropControl.in(store_id: @stores.pluck(:_id))
    @company_comments = @company.comments

    respond_to do |format|
      format.html
      format.xlsx {
        render xlsx: "list", disposition: "attachment", filename: "control_de_granos.xlsx"
      }
    end
  end

  def create
    @crop_control = CropControl.new(params[:crop_control])
    @crop_control.updater = current_user

    if @crop_control.save
      render json: @crop_control, status: :created, location: @crop_control
    else
      render json: @crop_control.errors, status: :unprocessable_entity
    end

  end

  def update
    @crop_control.update_attributes(params[:crop_control])
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

end
