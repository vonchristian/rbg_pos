module StoreFrontModule
  module LineItems
    class SalesReturnOrderLineItem < LineItem
      belongs_to :sales_return_order, class_name: "StoreFrontModule::Orders::SalesReturnOrder", foreign_key: 'order_id', optional: true
      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end

      def cost_of_goods_sold
        quantity * unit_cost
      end
    end
  end
end
