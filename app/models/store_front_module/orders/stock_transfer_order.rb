module StoreFrontModule
  module Orders
    class StockTransferOrder < Order

      belongs_to :destination_store_front, class_name: "StoreFront", foreign_key: 'destination_store_front_id', optional: true
      belongs_to :origin_store_front, class_name: "StoreFront", foreign_key: 'store_front_id'
      has_many :stock_transfer_order_line_items, class_name: "StoreFrontModule::LineItems::StockTransferOrderLineItem", foreign_key: 'order_id'

      delegate :name, to: :store_front, prefix: true, allow_nil: true
      delegate :name, to: :destination_store_front, prefix: true, allow_nil: true

      def total_cost
        stock_transfer_order_line_items.sum(&:total_cost)
      end
    end
  end
end
