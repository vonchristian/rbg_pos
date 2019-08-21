
module WorkOrders
  module SpareParts
    class Cancellation
      attr_reader :line_item, :work_order, :employee

      def initialize(args)
        @employee  = args.fetch(:employee)
        @line_item = args.fetch(:line_item)
        @work_order     = args.fetch(:work_order)
      end
      def cancel!
        create_entry
        delete_item
      end

      def create_entry
        store_front           = work_order.store_front
        accounts_receivable   = work_order.receivable_account
        cost_of_goods_sold    = store_front.cost_of_goods_sold_account
        sales                 = work_order.sales_revenue_account
        sales_discount        = work_order.sales_discount_account
        merchandise_inventory = store_front.merchandise_inventory_account
        employee.entries.create!(
          commercial_document: work_order.customer,
          entry_date: Date.current,
          description: "Sales Return - #{work_order.service_number}",
          credit_amounts_attributes: [{ amount: line_item.total_cost,
                                        account: credit_account,
                                        commercial_document: work_order},
                                      { amount: line_item.cost_of_goods_sold,
                                        account: cost_of_goods_sold,
                                        commercial_document: work_order} ],
            debit_amounts_attributes:[{amount: line_item.total_cost,
                                        account: sales,
                                        commercial_document: work_order},
                                       { amount: line_item.cost_of_goods_sold,
                                        account: merchandise_inventory,
                                        commercial_document: work_order}])
      end

      def delete_item
        line_item.referenced_purchase_order_line_items.destroy_all
        line_item.destroy
      end

      def credit_account
        work_order.receivable_account
      end
    end
  end
end
