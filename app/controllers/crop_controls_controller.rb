class CropControlsController < ApplicationController

  load_and_authorize_resource

  respond_to :json

  before_filter :require_company!
  before_filter :set_valid_params , :except => [:index,:list, :excel, :summary, :destroy]

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



    respond_to do |format|
      format.html do
        @crop_controls = CropControl.in(store_id: stores.pluck(:_id)).order_by(:fecha => :asc)
      end
      format.json do
        render json: @result
      end
      format.xlsx do
        @title = "Resumen Ctrl de Granos"
        render xlsx: "summary", disposition: "attachment", filename: "control_de_granos-resumen.xlsx"
      end
    end

  end

  def index
    @stores = @company.stores
    @crops = Crop.only(:_id,:name).all
    #todo: filter by company
    @crop_controls = CropControl.in(store_id: @stores.pluck(:_id)).order_by(:fecha => :asc)
    @company_comments = @company.comments

    respond_to do |format|
      format.html
    end
  end


  def excel
    @crop_controls = CropControl.in(_id: params[:ids] ).order_by(:fecha => :asc)
    @title = params[:title]
    render xlsx: "list", disposition: "attachment", filename: "control_de_granos.xlsx"
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
