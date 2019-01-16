class Business < ApplicationRecord
  has_many :customers
	has_many :store_fronts
  has_many :employees, class_name: "User"

  validates :name, presence: true
end
