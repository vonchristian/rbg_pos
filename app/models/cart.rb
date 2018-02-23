class Cart < ApplicationRecord
	has_many :line_items, dependent: :destroy
  has_many :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", dependent: :destroy
  has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", dependent: :destroy
  has_many :stock_transfer_order_line_items, class_name: "StoreFrontModule::LineItems::StockTransferOrderLineItem", dependent: :destroy
  has_many :sales_return_order_line_items, class_name: "StoreFrontModule::LineItems::SalesReturnOrderLineItem", dependent: :destroy
  has_many :purchase_return_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem", dependent: :destroy
  has_many :internal_use_order_line_items, class_name: "StoreFrontModule::LineItems::InternalUseOrderLineItem", dependent: :destroy

	def total_cost
		line_items.sum(:total_cost)
	end
end
