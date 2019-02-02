module StoreFrontModule
  module LineItems
    class StockTransferOrderLineItem < LineItem
      belongs_to :purchase_order_line_item
      belongs_to :purchase_order, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'order_id', optional: true
      delegate :purchase_order, to: :purchase_order_line_item
      def self.from_store_front(origin_store_front)
        origin_store_front.delivered_stock_transfers
      end
    end
  end
end
