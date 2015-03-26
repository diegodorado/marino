class CropControlsController < ApplicationController

  load_and_authorize_resource

  before_filter :require_company!


  def summary
    respond_to do |format|
      format.html do
      end
      format.xlsx do
        @result = CropControl.summary(params[:balance_at], @company.stores.pluck(:_id))
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



end
