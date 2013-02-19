class CropsController < ApplicationController
  # GET /crops
  # GET /crops.json
  def index
    @crops = Crop.all
  end

  # GET /crops/1
  def show
    @crop = Crop.find(params[:id])
  end

  # GET /crops/new
  def new
    @crop = Crop.new
  end

  # GET /crops/1/edit
  def edit
    @crop = Crop.find(params[:id])
  end

  # POST /crops
  def create
    @crop = Crop.new(params[:crop])

    if @crop.save
      redirect_to @crop, notice: 'Crop was successfully created.'
    else
      render action: "new" 
    end

  end

  # PUT /crops/1
  # PUT /crops/1.json
  def update
    @crop = Crop.find(params[:id])

    respond_to do |format|
      format.html do
        if @crop.update_attributes(params[:crop])
          redirect_to @crop, notice: 'Crop was successfully updated.'
        else
          render action: "edit"
        end
      end
      
      
      format.json do
        if @crop.update_price(params[:month], params[:price], current_user)
          head :no_content
        else
          render json: @crop.errors, status: :unprocessable_entity
        end
      end
      
    end
  end

  # DELETE /crops/1
  def destroy
    @crop = Crop.find(params[:id])
    @crop.destroy

    redirect_to crops_url

  end
end
