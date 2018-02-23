module StoreFrontModule
  module Orders
    class SpoilageOrder < Order
      has_many :spoilage_order_line_items, class_name: "StoreFrontModule::LineItems::SpoilageOrderLineItem", foreign_key: 'order_id'
      def total_cost
        spoilage_order_line_items.sum(&:total_cost)
      end
    end
  end
end
