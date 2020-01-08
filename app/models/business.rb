class Business < ApplicationRecord
  has_one :business_account_config
  has_many :customers
	has_many :store_fronts
  has_many :employees, class_name: "User"
  has_many :products
  has_many :accounts, class_name: 'AccountingModule::Account'
  has_many :work_orders, through: :store_fronts
  validates :name, presence: true
end
