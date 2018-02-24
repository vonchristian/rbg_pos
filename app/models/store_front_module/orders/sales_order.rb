module StoreFrontModule
  module Orders
    class SalesOrder < Order
      has_one :cash_payment, as: :cash_paymentable, class_name: "StoreFrontModule::CashPayment"
      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'order_id'

      delegate :name, to: :customer, prefix: true, allow_nil: true
      delegate :discount_amount, to: :cash_payment
      def customer
        commercial_document
      end
      def cost_of_goods_sold
        sales_order_line_items.cost_of_goods_sold
      end
      def total_cost
        sales_order_line_items.sum(&:total_cost)
      end
      def income
        total_cost - cost_of_goods_sold
      end
    end
  end
end
