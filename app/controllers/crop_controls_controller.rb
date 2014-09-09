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
    @company = current_company
    stores = @company.stores
    @crops = Crop.only(:_id,:name).all            
    respond_to do |format|
      format.html do
        @crop_controls = CropControl.in(store_id: stores.pluck(:_id))
      end
      format.xlsx do
      
        map = %Q{         
          function() { 
            emit(
              this.crop_id, 
              { 
                tn: (this.entrada-this.salida), 
                unit: this.precio_unitario }
              );  
          }
        }
            
        reduce = %Q{
          function(key, values) { 
            var result = { tn: 0, unit:0 };    
            
            values.forEach( function(value) {      
              result.tn += value.tn;      
              result.unit = value.unit;    
              });    
              
            return result;  }
        }


        @crop_controls = CropControl
          .in(store_id: stores.pluck(:_id))
          .where(:fecha.lte => params[:balance_at])
          .map_reduce(map, reduce)
          .out(inline: true)

      

    for crop_id, ccs of grouped

      data=
        crop: @crops.get(crop_id).get('name')
        gestion: {}
        contabilidad: {}

      gestion = _.filter ccs, (cc) -> cc.get('gestion')
      contabilidad = _.filter ccs, (cc) -> cc.get('contabilidad')

      data.gestion.tn = _.reduce gestion, ((memo, cc) -> memo + cc.tn() ) , 0
      data.gestion.unit = 0
      if gestion.length > 0
        data.gestion.unit = _.last(gestion).unit()
      data.gestion.total = data.gestion.tn * data.gestion.unit
      data.contabilidad.tn = _.reduce contabilidad, ((memo, cc) -> memo + cc.tn() ) , 0
      data.contabilidad.unit = 0
      if contabilidad.length > 0
        data.contabilidad.unit = _.last(contabilidad).unit()      
      data.contabilidad.total = data.contabilidad.tn * data.contabilidad.unit

      gestion_total += data.gestion.total
      contabilidad_total += data.contabilidad.total

          
      
      
        @title = "Resumen Ctrl de Granos"
        render xlsx: "summary", disposition: "attachment", filename: "control_de_granos-resumen.xlsx"
      end
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
    end
  end


  def excel
    @crop_controls = CropControl.in(_id: params[:ids] )
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
