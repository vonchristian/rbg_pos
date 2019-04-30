module StoreFrontModule
  module Orders
    class SalesReturnOrder < Order
      has_many :sales_return_order_line_items, class_name: "StoreFrontModule::LineItems::SalesReturnOrderLineItem", foreign_key: 'order_id'
      delegate :name, :full_name, to: :customer, prefix: true
      def customer
        commercial_document
      end
      def total_cost
        sales_return_order_line_items.sum(&:total_cost)
      end
      def balance
      end 
    end
  end
end
