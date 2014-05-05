class Admin::UsersController < ApplicationController

  load_and_authorize_resource

  def index
  end


  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to admin_users_path , notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
 
  end

end
