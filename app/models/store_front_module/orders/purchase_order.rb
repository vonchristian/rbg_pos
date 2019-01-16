module StoreFrontModule
  module Orders
    class PurchaseOrder < Order
      belongs_to :supplier, polymorphic: true

      belongs_to :destination_store_front, optional: true, class_name: "StoreFront", foreign_key: 'destination_store_front_id'
      has_many :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'order_id'

      delegate :name, to: :supplier, prefix: true, allow_nil: true
      delegate :name, to: :origin_store_front, prefix: true, allow_nil: true
      delegate :name, to: :destination_store_front, prefix: true, allow_nil: true

      def origin_store_front
        supplier
      end
      def total_cost
        purchase_order_line_items.sum(&:total_cost)
      end
      def stock_transfer?
        supplier_type == "StoreFront"
      end

      def self.stock_transfers
        where(supplier_type: "StoreFront")
      end
      def self.not_stock_transfers
        where(supplier_type: "Supplier")
      end
    end
  end
end
