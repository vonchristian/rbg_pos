module EntryCreators
  module WorkOrders 
    class SparePartCancellationEntry 
      attr_reader :employee, :work_order, :line_item

      def initialize(employee:, work_order:, line_item:)
        @employee = employee
        @work_order = work_order
        @line_item = line_item
      end 
      def create_entry!
        store_front           = work_order.store_front
        receivable_account    = work_order.receivable_account
        cost_of_goods_sold    = store_front.cost_of_goods_sold_account
        sales                 = work_order.sales_revenue_account
        sales_discount        = work_order.sales_discount_account
        merchandise_inventory = store_front.merchandise_inventory_account
        employee.entries.create!(
          commercial_document: work_order,
          entry_date: Date.current,
          description: "Sales Return - #{work_order.service_number}",
          credit_amounts_attributes: [{ amount: line_item.total_cost,
                                        account: receivable_account},
                                      { amount: line_item.cost_of_goods_sold,
                                        account: cost_of_goods_sold} ],
            debit_amounts_attributes:[{amount: line_item.total_cost,
                                        account: sales},
                                       { amount: line_item.cost_of_goods_sold,
                                        account: merchandise_inventory}])
      end
    end 
  end 
end 