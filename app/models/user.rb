class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy

  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: :post

  has_many :vieweds, dependent: :destroy
  has_many :viewed_posts, through: :vieweds, source: :post

  has_many :collections, dependent: :destroy
  has_many :collect_posts, through: :collections, source: :post

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  ROLE = {
    normal: "User",
    admin: "Admin"
  }

  def admin?
    self.role == "admin"
  end
end
