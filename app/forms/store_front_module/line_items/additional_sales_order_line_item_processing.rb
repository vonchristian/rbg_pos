module StoreFrontModule
  module LineItems
    class AdditionalSalesOrderLineItemProcessing
      include ActiveModel::Model
      attr_reader :sales_order, :cart, :employee, :date

      def initialize(args)
        @sales_order = args[:sales_order]
        @cart        = args[:cart]
        @employee    = args[:employee]
        @date        = args[:date]
      end
      def process!
        ActiveRecord::Base.transaction do
          create_entry
          add_items
          remove_cart_reference
        end
      end

      private
      def add_items
        cart.sales_order_line_items.each do |line_item|
          line_item.update_attributes!(date: date)
        end
        sales_order.sales_order_line_items << cart.sales_order_line_items

      end
      def create_entry
        store_front = employee.store_front
        accounts_receivable = sales_order.receivable_account
        cost_of_goods_sold = store_front.cost_of_goods_sold_account
        sales = sales_order.default_sales_revenue_account
        sales_discount = sales_order.sales_discount_account
        merchandise_inventory = store_front.merchandise_inventory_account
        employee.entries.create!(
          commercial_document: sales_order.customer,
          entry_date: date,
          description: "Credit sales",
          debit_amounts_attributes: [{ amount: cart.total_cost,
                                        account: accounts_receivable,
                                        commercial_document: sales_order},
                                      { amount: cart.cost_of_goods_sold,
                                        account: cost_of_goods_sold,
                                        commercial_document: sales_order } ],
            credit_amounts_attributes:[{amount: cart.total_cost,
                                        account: sales,
                                        commercial_document: sales_order},
                                       { amount: cart.cost_of_goods_sold,
                                        account: merchandise_inventory,
                                        commercial_document: sales_order}])
      end
      def remove_cart_reference
        cart.sales_order_line_items.each do |line_item|
          line_item.cart_id = nil
          line_item.save
        end
      end

    end
  end
end
