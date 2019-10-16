class Business < ApplicationRecord
  belongs_to :service_receivable_parent_account_category, class_name: 'AccountingModule::ParentAccountCategory'
  belongs_to :service_revenue_parent_account_category, class_name: 'AccountingModule::ParentAccountCategory'
  belongs_to :sales_revenue_parent_account_category,   class_name: 'AccountingModule::ParentAccountCategory'
  has_many :customers
	has_many :store_fronts
  has_many :employees, class_name: "User"
  has_many :products
  has_many :ledger_accounts, as: :ledgerable
  has_many :accounts, through: :ledger_accounts, class_name: 'AccountingModule::Account'
  validates :name, presence: true
end
