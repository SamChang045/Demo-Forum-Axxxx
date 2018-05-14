class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:show, :edit, :update, :destroy, :collect, :uncollect, :edit_current_comment]

  def index
    @categories = Category.all
    if current_user
      if params[:category_id]
        @category = Category.find(params[:category_id])
        @ransack = @category.posts.readable_posts(current_user).where(public: true).ransack(params[:q])
      else
        @ransack = Post.readable_posts(current_user).where(public: true).ransack(params[:q])
      end
    else
      if params[:category_id]
        @category = Category.find(params[:category_id])
        @ransack = @category.posts.where(public: true).where(authority: "all").ransack(params[:q])
      else
        @ransack = Post.where(public: true).where(authority: "all").ransack(params[:q])
      end
    end
      @posts = @ransack.result(distinct: true).includes(:comments).page(params[:page]).per(20)
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
    if @post.check_authority_for?(current_user)
      @post.vieweds.create(user: current_user) unless @post.viewed_by?(current_user)
      @comments = @post.comments.includes(:user).page(params[:page]).per(20)
      @comment = Comment.new
    else
      flash[:alert] = "Has no authority."
      redirect_to posts_path
    end
  end

  def collect
    @post.collections.create(user: current_user)
    respond_to do |format|
      format.js
    end
  end

  def uncollect
    @collect = @post.collections.find_by(user: current_user)
    @collect.destroy
    respond_to do |format|
      format.js
    end
  end  

  def edit_current_comment
    @comment = @post.comments.find_by(id: params[:comment_id])
    respond_to do |format|
      format.js
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image, :public, :authority, category_ids: [])
  end
end
