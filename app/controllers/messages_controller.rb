class MessagesController < ApplicationController

  load_and_authorize_resource

  respond_to :json

  def index
    respond_with @messages
  end


  def show
    respond_with @message
  end

  def create
    @message = Message.new(params)
    @message.creator = current_user

    puts @message.to_json
    
    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end

  end

  def update
    @message.updater = current_user


    if @message.update_attributes(params)
      puts params
      puts @message.to_json
      render json: @message, status: :ok
    else
      render json: @message.errors, status: :unprocessable_entity
    end

  end

  def destroy
    @message.destroy
    head :ok
  end

end
