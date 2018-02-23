class StoreFront < ApplicationRecord
  belongs_to :business
  belongs_to :merchandise_inventory_account, class_name: "AccountingModule::Account", foreign_key: 'merchandise_inventory_account_id'
  belongs_to :sales_account, class_name: "AccountingModule::Account", foreign_key: 'sales_account_id'
  belongs_to :sales_discount_account, class_name: "AccountingModule::Account", foreign_key: 'sales_discount_account_id'
  belongs_to :sales_return_account, class_name: "AccountingModule::Account", foreign_key: 'sales_return_account_id'
  belongs_to :cost_of_goods_sold_account, class_name: "AccountingModule::Account", foreign_key: 'cost_of_goods_sold_account_id'

  has_many :received_stock_transfer_orders, class_name: "StoreFrontModule::Orders::StockTransferOrder", as: :commercial_document
  def default_sales_return_account
    AccountingModule::Revenue.find_by(name: "Sales Returns")
  end
  def default_accounts_receivable_account
    AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
  end

  def default_internal_use_expenses_account
    AccountingModule::Expense.find_by(name: "Internal Use Expenses")
  end
end
