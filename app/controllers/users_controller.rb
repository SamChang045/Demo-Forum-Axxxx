class UsersController < ApplicationController
  before_action :set_user, only: [:show, :comments]
  def show
    @posts = @user.posts
  end

  def comments
    @comments = @user.comments
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
