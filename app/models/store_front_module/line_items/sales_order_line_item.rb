module StoreFrontModule
  module LineItems
    class SalesOrderLineItem < LineItem
      belongs_to :sales_order, class_name: "StoreFrontModule::Orders::SalesOrder", foreign_key: 'order_id', optional: true
      delegate :customer, :date, :official_receipt_number, :reference_number, :customer_name, to: :sales_order, allow_nil: true
      delegate :purchase, to: :stock
      delegate :unit_cost, to: :purchase, prefix: true, allow_nil: true

      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end

      def cost_of_goods_sold
        if stock.present? && purchase_unit_cost
          quantity * purchase_unit_cost
        else
          0
        end
      end

      def available_quantity
        quantity - referenced_sales_order_line_items.total
      end
    end
  end
end
