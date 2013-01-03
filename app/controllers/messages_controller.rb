class MessagesController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :json

  def create
    @message.creator = current_user

    if @message.save
      redirect_to messages_url, notice: "Message was successfully created. (#{Message.count})"
    else
      render action: "new"
    end

  end

  def update
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

  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    redirect_to messages_url , notice: 'Message was successfully removed.'
  end

end
