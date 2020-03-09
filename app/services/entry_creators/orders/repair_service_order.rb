module EntryCreators
  module Orders
    class RepairServiceOrder
      attr_reader :sales_order, :work_order, :employee, :customer, :receivable_account, :sales_revenue_account, :cost_of_goods_sold_account, :merchandise_inventory_account
      
      def initialize(sales_order:, work_order:, employee:)
        @sales_order                   = sales_order 
        @customer                      = @sales_order.customer
        @work_order                    = work_order
        @employee                      = employee
        @store_front                   = @employee.store_front
        @receivable_account            = @work_order.receivable_account
        @cost_of_goods_sold_account    = @store_front.cost_of_goods_sold_account
        @sales_revenue_account         = @work_order.sales_revenue_account
        @merchandise_inventory_account = @store_front.merchandise_inventory_account
      end 

      def create_entry!
       
        entry = employee.entries.build(
        commercial_document: customer,
        entry_date:          sales_order.date,
        description:         "Spare parts for work order ##{work_order.service_number}")

        entry.debit_amounts.build(
          amount:  sales_order.total_cost,
          account: receivable_account)

        entry.debit_amounts.build(
          amount:  sales_order.cost_of_goods_sold,
          account: cost_of_goods_sold_account)

        entry.credit_amounts.build(
          amount:  sales_order.total_cost,
          account: sales_revenue_account )

        entry.credit_amounts.build(
          amount:  sales_order.cost_of_goods_sold,
          account: merchandise_inventory_account)

        entry.save!
      end 
    end 
  end
end 
                                       