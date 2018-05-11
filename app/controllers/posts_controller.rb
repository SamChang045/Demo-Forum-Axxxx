class PostsController < ApplicationController
  before_action :authenticate_user! 
  def index
    @categories = Category.all
    @posts = Post.all
  end 
end
