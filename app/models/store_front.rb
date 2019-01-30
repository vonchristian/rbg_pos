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
  belongs_to :service_revenue_account,       class_name: "AccountingModule::Account", foreign_key: 'service_revenue_account_id'

  has_many :sales_orders,                    class_name: "StoreFrontModule::Orders::SalesOrder", foreign_key: 'store_front_id'
  has_many :delivered_stock_transfer_orders, class_name: "StoreFrontModule::Orders::PurchaseOrder", as: :supplier
  has_many :received_stock_transfer_orders,  class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'destination_store_front_id'
  has_many :delivered_stock_transfers,       through: :delivered_stock_transfer_orders, source: :purchase_order_line_items
  has_many :received_stock_transfers,        through:  :received_stock_transfer_orders, source: :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem"
  has_many :work_orders
  validates :name, presence: true

  delegate :name, to: :business, prefix: true


  def payable_account
    merchandise_inventory_account
  end
end
