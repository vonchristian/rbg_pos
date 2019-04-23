class Business < ApplicationRecord
  has_many :customers
	has_many :store_fronts
  has_many :employees, class_name: "User"
  has_many :products
  has_many :accounts, class_name: 'AccountingModule::Account'

  validates :name, presence: true
end
