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

    respond_to do |format|
      format.html do
      end
      format.xlsx do
        @result = CropControl.list(params[:store_id],params[:crop_id],params[:gestion].to_i==1)
        @title = params[:title]
        @title = "Ctrl de Granos"
        render xlsx: "crop_controls/index", disposition: "attachment", filename: "control_de_granos.xlsx"
      end
    end

  end

end
