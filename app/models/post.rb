class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, source: :user
end