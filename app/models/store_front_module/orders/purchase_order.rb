module StoreFrontModule
  module Orders
    class PurchaseOrder < Order

      has_many :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'order_id'

      delegate :name, to: :supplier, prefix: true
      def supplier
        commercial_document
      end
      def total_cost
        purchase_order_line_items.sum(&:total_cost)
      end
    end
  end
end
