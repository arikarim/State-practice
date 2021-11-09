class Role < ApplicationRecord
  has_many :assintments
  has_many :users, through: :assintments
end
