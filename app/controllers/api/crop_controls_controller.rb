class Api::CropControlsController < ApplicationController
  load_and_authorize_resource
  respond_to :json, :xlsx
  before_filter :require_company!

  def summary
    @result = CropControl.summary(params[:balance_at], @company.stores.pluck(:_id))
    render json: @result
  end

  def index
    filter= params.select{|k,v| ["store_id","crop_id"].include?(k)}
    if params[:gestion]
      filter[:gestion] = true
    else
      filter[:contabilidad] = true
    end
    @result = CropControl
      .where(filter)
      .order_by(:fecha => :asc)

    precio_anterior = 0
    saldo = 0
    saldo_p = 0
    @result = @result.map do |doc|
      saldo += doc[:entrada]-doc[:salida];
      doc[:saldo] = saldo.round(3)

      if doc[:tipo_doc] == 'VALUACION'
        cant =  (doc[:precio_unitario]  - precio_anterior) * saldo
        if cant >= 0
          doc[:debe] = cant
          doc[:haber] = 0
        else
          doc[:debe] = 0
          doc[:haber] = -cant
        end
      else
        doc[:debe] = doc[:entrada]*doc[:precio_unitario]
        doc[:haber] = doc[:salida]*doc[:precio_unitario]

      end

      saldo_p += doc[:debe]-doc[:haber]
      doc[:saldo_p] = saldo_p
      #watch out! first item cant be valuacion
      precio_anterior = doc[:precio_unitario]

      doc
    end

    respond_to do |format|
      format.json do
        render json: @result
      end
      format.xlsx do
        @title = params[:title]
        @title = "Ctrl de Granos"
        render xlsx: "crop_controls/index", disposition: "attachment", filename: "control_de_granos.xlsx"
      end
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
