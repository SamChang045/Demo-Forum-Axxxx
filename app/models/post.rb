class Post < ApplicationRecord
  belongs_to :user

  has_many :categories_posts
  has_many :categories, through: :categories_posts

  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, source: :user

  has_many :collections, dependent: :destroy
  has_many :collect_users, through: :collections, source: :user

  has_many :vieweds, dependent: :destroy
  has_many :viewed_users, through: :vieweds, source: :user

  mount_uploader :image, PhotoUploader
  
  def collected_by?(user)
    self.collect_users.include?(user)
  end

  def viewed_by?(user)
    self.viewed_users.include?(user)
  end

  def self.readable_posts(user)
    Post.where(authority: "friend", user: user.all_friends).or(where(authority: "all")).or(where(authority: "myself", user: user)).or(where(user: user))
  end

  def check_authority_for?(user)
    Post.readable_posts(user).include?(self)
  end
end