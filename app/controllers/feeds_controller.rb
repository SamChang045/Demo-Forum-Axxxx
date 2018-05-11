class FeedsController < ApplicationController
    @user_count = User.all.count
    @post_count = Post.all.count
    @comment_count = Comment.all.count
    @users = User.select(:id, :name, :comments_count).order(comments_count: :desc).limit(10)
    @posts = Post.select(:id, :title, :comments_count, :updated_at).order(comments_count: :desc).limit(10)
end
