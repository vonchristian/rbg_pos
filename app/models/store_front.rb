class StoreFront < ApplicationRecord
  belongs_to :business
  belongs_to :merchandise_inventory_account, class_name: "AccountingModule::Account", foreign_key: 'merchandise_inventory_account_id'
  belongs_to :sales_account,                 class_name: "AccountingModule::Account", foreign_key: 'sales_account_id'
  belongs_to :sales_discount_account,        class_name: "AccountingModule::Account", foreign_key: 'sales_discount_account_id'
  belongs_to :sales_return_account,          class_name: "AccountingModule::Account", foreign_key: 'sales_return_account_id'
  belongs_to :cost_of_goods_sold_account,    class_name: "AccountingModule::Account", foreign_key: 'cost_of_goods_sold_account_id'
  belongs_to :receivable_account,            class_name: "AccountingModule::Account", foreign_key: 'receivable_account_id'
  belongs_to :internal_use_account,          class_name: "AccountingModule::Account", foreign_key: 'internal_use_account_id'
  belongs_to :purchase_return_account,       class_name: "AccountingModule::Account", foreign_key: 'purchase_return_account_id'
  belongs_to :spoilage_account,              class_name: "AccountingModule::Account", foreign_key: 'spoilage_account_id'

  has_many :sales_orders, class_name: "StoreFrontModule::Orders::SalesOrder", foreign_key: 'store_front_id'

  has_many :delivered_stock_transfer_orders, class_name: "StoreFrontModule::Orders::PurchaseOrder", as: :supplier
  has_many :received_stock_transfer_orders, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'destination_store_front_id'

  has_many :delivered_stock_transfers, through: :delivered_stock_transfer_orders, source: :purchase_order_line_items

  has_many :received_stock_transfers, through:  :received_stock_transfer_orders, source: :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem"
  delegate :name, to: :business, prefix: true
  def default_sales_return_account
    AccountingModule::Revenue.find_by(name: "Sales Returns")
  end
  def default_accounts_receivable_account
    AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
  end

  def default_internal_use_expenses_account
    AccountingModule::Expense.find_by(name: "Internal Use Expenses")
  end
  def default_spoilages_account
    AccountingModule::Expense.find_by(name: "Spoilage, Breakage and Losses (Selling/Marketing Cost)")
  end
  def default_other_income_account
    AccountingModule::Revenue.find_by(name: 'Other Income')
  end
  def payable_account
    merchandise_inventory_account
  end
  def delivered_stock_transfers_balance(args={})
    delivered_stock_transfers.balance(args)
  end

  def received_stock_transfers_balance(args={})
    received_stock_transfers.balance(args)
  end
end
