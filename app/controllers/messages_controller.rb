class MessagesController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :json

  def index
    respond_with @messages
  end

  def show
    respond_with @message
  end

  def new
    respond_with @message
  end

  def edit
    respond_with @message
  end

  def create
    @message.creator = current_user
    @message.save
    redirect_to messages_url
  end

  # POST /messages
  # POST /messages.json
  def create2
    @message = Message.new(params[:message])
    @message.creator = current_user

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_url, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])
    @message.updater = current_user

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to messages_url, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
end
