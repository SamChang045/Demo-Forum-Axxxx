class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy

  ROLE = {
    normal: "User",
    admin: "Admin"
  }

  def admin?
    self.role == "admin"
  end
end
