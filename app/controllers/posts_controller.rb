class PostsController < ApplicationController
  before_action :authenticate_user! 
  def index
    @categories = Category.all
    @posts = Post.page(params[:page]).per(10)
  end 

  def new
    @post = Post.new
  end
end
