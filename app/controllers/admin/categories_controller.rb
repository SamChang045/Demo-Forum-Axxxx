class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  before_action :set_category, only: [:update, :destroy]

  def index
    @categories = Category.all
    if params[:id]
      @category = Category.find(params[:id])
    else
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category Completed"
    else
      @categories = Category.all
      render :index
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category Updated"
    else
      @categories = Category.all
      render :index
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_categories_path, notice: "Category Deleted"
    else
      flash[:alert] = @category.errors.full_messages.to_sentence
      redirect_to admin_categories_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
