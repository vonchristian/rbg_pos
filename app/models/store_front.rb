class StoreFront < ApplicationRecord
  belongs_to :business
  belongs_to :merchandise_inventory_account, class_name: "AccountingModule::Account"
  has_many :received_stock_transfer_orders, class_name: "StoreFrontModule::Orders::StockTransferOrder", as: :commercial_document
end
