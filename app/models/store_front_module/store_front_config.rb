module StoreFrontModule
  class StoreFrontConfig < ApplicationRecord
    belongs_to :accounts_receivable_account, class_name: "AccountingModule::Account"
    belongs_to :store_front
    def self.default_cost_of_goods_sold_account
      AccountingModule::Expense.find_by(name: "Cost of Goods Sold")
    end
    def self.default_sales_account
      AccountingModule::Revenue.find_by(name: "Sales")
    end
    def self.default_merchandise_inventory_account
      AccountingModule::Asset.find_by(name: "Merchandise Inventory")
    end
  end
end
