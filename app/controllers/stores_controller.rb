class StoresController < ApplicationController

  load_and_authorize_resource

  # index, show, new, edit

  def create
    @store = Store.new(params[:store])

    if @store.save
      redirect_to @store, notice: 'Store was successfully created.'
    else
      render action: "new"
    end

  end

  def update
    @store = Store.find(params[:id])

    if @store.update_attributes(params[:store])
      redirect_to @store, notice: 'Store was successfully updated.'
    else
      render action: "edit"
    end

  end

  def destroy
    @store.destroy

    redirect_to stores_url

  end
end
