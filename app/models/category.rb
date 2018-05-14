class Category < ApplicationRecord
  has_many :categories_posts, dependent: :restrict_with_error
  has_many :posts, through: :categories_posts  
end
