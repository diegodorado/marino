class Api::CropControlsController < ApplicationController
  load_and_authorize_resource
  respond_to :json
  before_filter :require_company!

  def summary
    stores = @company.stores
    @crops = Crop.only(:_id,:name).all

    map = %Q{
      function() {

        var values = {
          tn_gest: this.gestion ?  (this.entrada-this.salida) : 0,
          unit_gest: this.gestion ? this.precio_unitario : 0,
          tn_cont: this.contabilidad ?  (this.entrada-this.salida) : 0,
          unit_cont: this.contabilidad ? this.precio_unitario : 0
          };

          emit( this.crop_id, values);
        }
      }

    reduce = %Q{
      function(key, values) {

        var result =  {tn_gest: 0, unit_gest:0,  tn_cont: 0, unit_cont:0 };

        values.forEach( function(value) {
          result.tn_gest += value.tn_gest;
          result.unit_gest = value.unit_gest;
          result.tn_cont += value.tn_cont;
          result.unit_cont = value.unit_cont;
          });

          return result;
        }
      }

    @result = CropControl.in(store_id: stores.pluck(:_id))
      .where(:fecha.lte => params[:balance_at])
      .order_by(:fecha => :asc)
      .map_reduce(map, reduce)
      .out(inline: 1)
      .map do |x|
        x["value"]["cropname"] = Crop.find(x["_id"]).name
        x["value"]
      end

    render json: @result

  end

  def index
    stores = @company.stores
    @result = CropControl.in(store_id: stores.pluck(:_id))
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
