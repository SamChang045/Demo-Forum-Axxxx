class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :drafts, :comments, :collects, :friends]
  def show
    @posts = @user.posts.readable_posts(current_user).where(public: true)
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def comments
    @comments = @user.comments
  end

  def collects
    @collections = @user.collect_posts
  end

  def drafts
    @drafts = @user.posts.where(public: false)
  end

  def friends
    @friends = @user.all_friends
    @not_yet_accepted_by_friends = @user.not_yet_accepted_by_friends
    @not_yet_responded_to_friends = @user.not_yet_responded_to_friends    
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :description, :avatar)
  end
end
