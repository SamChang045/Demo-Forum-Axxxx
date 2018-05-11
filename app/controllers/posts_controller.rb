class PostsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    @posts = Post.page(params[:page]).per(10)
  end 

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:commit] == "Save Draft"
      @post.public = false
      if @post.save
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :new
      end
    else
      @post.public = true
      if @post.save
        redirect_to post_path(@post)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :new
      end
    end
  end

  def update
    if params[:commit] == "Save Draft"
      @post.public = false
      if @post.update(post_params)
        flash[:notice] = "Save Compeleted!"
        redirect_to drafts_user_path(current_user)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :edit
      end
    else
      @post.public = true
      if @post.update(post_params)
        flash[:notice] = "Article Posted!"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def show
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image, :public, :authority, :category_id)
  end
end
