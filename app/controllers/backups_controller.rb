class BackupsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    @backup = Backup.new
    respond_with @backups
  end

  def show
    zip_content = @backup.zip.read
    send_data zip_content, :filename => @backup[:zip]
  end

  def new
    respond_with @backup
  end

  def create
    @backup.creator = current_user

    if @backup.save
      redirect_to backups_url , notice: "Backup creado con exito"
    else
      redirect_to backups_url , :flash => { :error => @backup.errors.full_messages.join(" - ") }
    end

  end

  def destroy
    @backup.destroy
    redirect_to backups_url, notice: 'Backup was successfully removed.'
  end

end
