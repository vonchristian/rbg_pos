class Cart < ApplicationRecord
	has_many :line_items, dependent: :destroy
  has_many :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", dependent: :destroy
  has_many :stock_transfer_order_line_items, class_name: "StoreFrontModule::LineItems::StockTransferOrderLineItem", dependent: :destroy

  has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", dependent: :destroy
  has_many :delivered_stock_transfer_order_line_items, class_name: "StoreFrontModule::LineItems::DeliveredStockTransferOrderLineItem", dependent: :destroy

  has_many :sales_return_order_line_items, class_name: "StoreFrontModule::LineItems::SalesReturnOrderLineItem", dependent: :destroy
  has_many :purchase_return_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem", dependent: :destroy
  has_many :internal_use_order_line_items, class_name: "StoreFrontModule::LineItems::InternalUseOrderLineItem", dependent: :destroy
  has_many :spoilage_order_line_items, class_name: "StoreFrontModule::LineItems::SpoilageOrderLineItem", dependent: :destroy
  has_many :other_sales_line_items
	def total_cost
		line_items.sum(:total_cost)
	end
  def cost_of_goods_sold
    sales_order_line_items.map{|a| a.cost_of_goods_sold }.sum
  end
end
