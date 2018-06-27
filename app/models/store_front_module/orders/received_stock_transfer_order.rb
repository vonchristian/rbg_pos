module StoreFrontModule
  module Orders
    class ReceivedStockTransferOrder < Order
      belongs_to :destination_store_front, class_name: "StoreFront", foreign_key: 'destination_store_front_id'
      has_many :purchase_order_line_items,
               class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'order_id'
      delegate :name, to: :origin_store_front, prefix: true
      def total_cost
        purchase_order_line_items.sum(&:total_cost)
      end
      def origin_store_front
        commercial_document
      end
    end
  end
end
