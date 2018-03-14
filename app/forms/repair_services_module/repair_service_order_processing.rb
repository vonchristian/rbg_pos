module RepairServicesModule
  class RepairServiceOrderProcessing
    include ActiveModel::Model
    attr_accessor :customer_id, :employee_id, :cart_id, :date, :work_order_id
    validates :customer_id, :date, presence: true
    def process!
      ActiveRecord::Base.transaction do
        create_repair_service_order
      end
    end

    private

    def create_repair_service_order
      order  = find_work_order.spare_part_orders.create(
        date: date,
        employee: find_employee)

      find_cart.sales_order_line_items.each do |sales_order_line_item|
        sales_order_line_item.cart_id = nil
        order.sales_order_line_items << sales_order_line_item
      end
      create_entry(order)
    end
    def create_entry(order)
        accounts_receivable = find_work_order.store_front.default_accounts_receivable_account
        cost_of_goods_sold = find_employee.store_front.cost_of_goods_sold_account
        sales = find_employee.store_front.sales_account
        merchandise_inventory = find_employee.store_front.merchandise_inventory_account
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_customer,
          entry_date: order.date,
          description: "Spare parts for work order ##{find_work_order.formatted_service_number}",
          debit_amounts_attributes: [{  amount: order.total_cost,
                                        account: accounts_receivable,
                                        commercial_document: find_work_order},
                                      { amount: order.cost_of_goods_sold,
                                        account: cost_of_goods_sold,
                                        commercial_document: find_work_order } ],
            credit_amounts_attributes:[{amount: order.total_cost,
                                        account: sales,
                                        commercial_document: find_work_order},
                                       {amount: order.cost_of_goods_sold,
                                        account: merchandise_inventory,
                                        commercial_document: find_work_order}])
      end
      def find_customer
        Customer.find_by_id(customer_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      def find_cart
        Cart.find_by_id(cart_id)
      end
      def find_work_order
        WorkOrder.find_by_id(work_order_id)
      end
  end
end
