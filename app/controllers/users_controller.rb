class UsersController < ApplicationController
  before_action :set_user, only: [:show, :comments]
  def show
    @posts = @user.posts
  end

  def comments
    @comments = @user.comments
  end

  def collects
    @collections = @user.collect_posts
  end

  def drafts
    @drafts = @user.posts
  end

  def friends
    @friends = @user.all_friends
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
