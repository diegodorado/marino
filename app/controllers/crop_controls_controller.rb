class CropControlsController < ApplicationController

  load_and_authorize_resource

  respond_to :json

  def create
    #params.keep_if {| key, value | [:fecha, :tipo_doc,:entrada,:salida, :precio_unitario, :store_id, :crop_id, :comentario].include?(key.to_sym) }
    @crop_control = CropControl.new(params[:crop_control])
    @crop_control.updater = current_user
    @crop_control.save!

    if @crop_control.save
      render json: @crop_control, status: :created, location: @crop_control
    else
      render json: @crop_control.errors, status: :unprocessable_entity
    end

  end

  def update
    #params.keep_if {| key, value | [:fecha, :tipo_doc,:entrada,:salida, :precio_unitario, :comentario].include?(key.to_sym) }
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
