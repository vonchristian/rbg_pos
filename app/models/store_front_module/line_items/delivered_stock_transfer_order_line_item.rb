module StoreFrontModule
  module LineItems
    class DeliveredStockTransferOrderLineItem < LineItem
      belongs_to :stock_transfer_order, class_name: "StoreFrontModule::Orders::StockTransferOrder", foreign_key: 'order_id', optional: true
      has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", as: :referencer, dependent: :destroy
    end
  end
end
