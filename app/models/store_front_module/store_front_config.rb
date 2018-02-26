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
    def self.default_accounts_receivable_account
      return self.last.accounts_receivable_account if self.last.present? && self.last.accounts_receivable_account.present?
      AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
    end
    def self.default_discount_account
      AccountingModule::Revenue.find_by(name: "Sales Discounts")
    end
    def income
      total_sales -
      total_cogs -
      total_discounts -
      tota_sales_returns
    end
    def default_accounts_receivable_account
      return accounts_receivable_account if accounts_receivable_account.present?
      AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
    end
  end
end
