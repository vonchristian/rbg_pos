class Cart < ApplicationRecord
	has_many :line_items, dependent: :destroy
  has_many :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", dependent: :destroy
  has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", dependent: :destroy

	def total_cost
		line_items.sum(:total_cost)
	end
end
