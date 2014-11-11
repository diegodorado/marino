class BackupsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json
  #before_filter :require_company!

  def index
    @backup = Backup.new
    @backups = @backups.order_by( :created_at => 'desc')
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
    @backup.company = current_company if current_company 

    if @backup.save
      if current_company.auditor
        ActionMailer::Base.mail(:from => current_user.email, :to => current_company.auditor.email, :subject => "Nuevo Backup Creado", :body => "#{current_user.email} ha creado un backup sobre la empresa #{current_company.name}").deliver
      end
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
