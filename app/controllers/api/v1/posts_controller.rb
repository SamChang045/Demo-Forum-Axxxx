class Api::V1::PostsController < ApplicationController

  before_action :authenticate_user!, except: :index

  def index
    @posts = Post.all
    render json: {
      data: @posts
    }
  end

  def show
    @post = Post.find_by(id: params[:id])
    if !@post
      render json: {
        error: "ERROR",
        message: "Can't find the post!"
      }
    else
      if Post.readable_posts(current_user).include?(@post)
        @post.vieweds.create(user: current_user) unless @post.viewed_by?(current_user)
        @comments = @post.comments
        render json: @post
      else
        render json: {
          error: "ERROR",
          message: "Sorry! you have no right to do that."
        }
      end
    end
  end

end
