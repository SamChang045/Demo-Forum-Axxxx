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

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      render json: {
        message: "Post posted successfully.",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def update
    if @post.update(post_params)
      render json: {
        message: "Post updated successfully.",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def destroy
    @post.destroy
    render json: {
      message: "Post deleted successfully"
    }
  end

  private

  def post_params
    params.permit(:title, :content, :image, :public, :authority, :category_id)
  end
end
