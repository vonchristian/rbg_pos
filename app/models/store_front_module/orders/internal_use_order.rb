module StoreFrontModule
  module Orders
    class InternalUseOrder < Order
      has_many :internal_use_order_line_items, class_name: "StoreFrontModule::LineItems::InternalUseOrderLineItem", foreign_key: 'order_id'
      delegate :name, to: :employee, prefix: true
      def employee
        commercial_document
      end
      def total_cost
        internal_use_order_line_items.sum(&:total_cost)
      end
    end
  end
end
