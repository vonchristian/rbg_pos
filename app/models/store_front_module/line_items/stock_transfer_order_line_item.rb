module StoreFrontModule
  module LineItems
    class StockTransferOrderLineItem < LineItem
      belongs_to :purchase_order_line_item, optional: true
      belongs_to :purchase_order, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'order_id', optional: true
      delegate :date, to: :purchase_order, prefix: true
      delegate :destination_store_front_name, :reference_number, to: :purchase_order
      def self.from_store_front(origin_store_front)
        origin_store_front.delivered_stock_transfers
      end
    end
  end
end
