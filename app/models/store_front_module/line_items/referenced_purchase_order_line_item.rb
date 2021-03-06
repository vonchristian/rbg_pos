module StoreFrontModule
  module LineItems
    class ReferencedPurchaseOrderLineItem < LineItem
      belongs_to :sales_order_line_item,    class_name: 'StoreFrontModule::LineItems::SalesOrderLineItem',       optional: true
      belongs_to :purchase_order_line_item, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem",    optional: true

      delegate :purchase_cost, to: :purchase_order_line_item

      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end

      def self.processed
        select{ |a| a.purchase_order_line_item.processed? }
      end

      def cost_of_goods_sold
        unit_cost * quantity
      end
    end
  end
end
