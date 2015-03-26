class Api::CropControlsController < ApplicationController
  load_and_authorize_resource
  respond_to :json
  before_filter :require_company!

  def summary
    @result = CropControl.summary(params[:balance_at], @company.stores.pluck(:_id))
    render json: @result
  end

  def index
    stores = @company.stores
    @result = CropControl.in(store_id: params[:store_id],crop_id: params[:crop_id])
      .order_by(:fecha => :asc)

    precio_anterior = 0
    saldo = 0
    saldo_p = 0
    @result = @result.map do |doc|
      saldo += doc[:entrada]-doc[:salida];
      doc[:saldo] = saldo.round(3)


      if doc[:tipo_doc] == 'VALUACION'

        #=F17*E17-F16*E16
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

        saldo_p += doc[:debe]-doc[:haber]
        doc[:saldo_p] = saldo_p
        #watch out! first item cant be valuacion
        precio_anterior = doc[:precio_unitario]
      end

      doc
    end

    render json: @result

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
