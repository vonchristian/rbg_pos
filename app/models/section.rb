class Section < ApplicationRecord
  has_many :users 
  has_many :work_orders, through: :users
end
