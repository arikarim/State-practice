class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_many :assintments
  has_many :roles, through: :assintments

  def has_role?(role)
    roles.any? { |r| r.name.to_sym == role.to_sym }
  end
end
