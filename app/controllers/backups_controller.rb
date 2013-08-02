class BackupsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    #respond_with @backups
  end

  def show
    zip_content = @backup.zip.read
    send_data zip_content, :filename => @backup.zip.identifier
  end

  def new
    respond_with @backup
  end

  def create
    #@backup.creator = current_user

    if @backup.save
      redirect_to backups_url , notice: "Backup was successfully created. (#{Backup.count})"
    else
      render action: "new" 
    end

  end

  def destroy
    @backup.destroy
    redirect_to backups_url, notice: 'Backup was successfully removed.' 
  end
  
end
