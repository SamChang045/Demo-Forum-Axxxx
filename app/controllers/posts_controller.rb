class PostsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @ransack = @category.posts.ransack(params[:q])
    else
      @ransack = Post.ransack(params[:q])
    end
    @posts = @ransack.result(distinct: true).page(params[:page]).per(20)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:commit] == "Save Draft"
      @post.public = false
      if @post.save
        redirect_to drafts_user_path(current_user)
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

  def destroy
    if @post.public
      @post.destroy
      flash[:notice] = "Article was deleted!"
      redirect_to user_path(current_user)
    else
      @post.destroy
      flash[:notice] = "Draft was deleted!"
      redirect_to drafts_user_path(current_user)
    end
  end  

  def show
    @comments = @post.comments.page(params[:page]).per(10)
    @comment = Comment.new
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image, :public, :authority, :category_id)
  end
end
