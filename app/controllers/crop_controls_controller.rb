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
                gestion: this.gestion,
                contabilidad: this.contabilidad,
                tn: (this.entrada-this.salida), 
                unit: this.precio_unitario }
              );  
          }
        }
            
        reduce = %Q{
          function(key, values) { 
            var result = {tn_gest: 0, unit_gest:0,  tn_cont: 0, unit_cont:0 };    
            
            values.forEach( function(value) {
                if(value.gestion){
                  result.tn_gest += value.tn;      
                  result.unit_gest = value.unit;    
                }
                if(value.contabilidad){
                  result.tn_cont += value.tn;      
                  result.unit_cont = value.unit;    
                }
              });    
              
            return result;  
            }
        }


        @result = CropControl.in(store_id: stores.pluck(:_id)).where(:fecha.lte => params[:balance_at]).map_reduce(map, reduce).out(inline: 1)

        @result = @result.each{|x| x}
        crop_ids = @result.map{|x| x["_id"]}

        crops = Crop.in(_id: crop_ids).all
        crops.each do |c|
          @result.map do |r|
            if r["_id"] == c.id
              r["value"]["cropname"] = c.name
            end
          end
        end
        @result = @result.map{|x| x["value"]}

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
