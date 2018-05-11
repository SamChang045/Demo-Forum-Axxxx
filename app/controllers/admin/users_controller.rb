class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    @user = User.find(params[:id])
    if @user.email == "admin@example.com"
      flash[:alert] = "Admin has no right to change!"
      redirect_to admin_users_path
    end
  end
end
