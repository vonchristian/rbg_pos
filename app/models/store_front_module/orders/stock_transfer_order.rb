module StoreFrontModule
  module Orders
    class StockTransferOrder < Order
      has_many :stock_transfer_order_line_items, class_name: "StoreFrontModule::LineItems::StockTransferOrderLineItem", foreign_key: 'order_id'
      delegate :name, to: :store_front, prefix: true
      def store_front
        commercial_document
      end
      def total_cost
        stock_transfer_order_line_items.sum(&:total_cost)
      end

    end
  end
end
