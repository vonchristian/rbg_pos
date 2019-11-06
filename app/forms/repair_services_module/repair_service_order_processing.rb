module RepairServicesModule
  class RepairServiceOrderProcessing
    include ActiveModel::Model
    attr_accessor :customer_id, :employee_id, :cart_id, :date, :work_order_id, :reference_number
    validates :customer_id, :date, presence: true
    def process!
      ActiveRecord::Base.transaction do
        create_repair_service_order
      end
    end

    private

    def create_repair_service_order
      order  = find_work_order.sales_orders.create!(
        date:           date,
        store_front:    find_work_order.store_front,
        account_number: SecureRandom.uuid,
        reference_number: reference_number,
        search_term: find_customer.name,
        employee: find_employee)

      find_cart.sales_order_line_items.each do |sales_order_line_item|
        sales_order_line_item.cart_id = nil
        order.sales_order_line_items << sales_order_line_item
      end
      create_entry(order)
      create_accounts(order)
    end
    def create_accounts(order)
      AccountCreators::SalesOrder.new(sales_order: order).create_accounts!
    end
    def create_entry(order)
        accounts_receivable = find_work_order.receivable_account
        cost_of_goods_sold = find_work_order.store_front.cost_of_goods_sold_account
        sales = find_work_order.store_front.sales_account
        merchandise_inventory = find_work_order.store_front.merchandise_inventory_account
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_customer,
          entry_date: order.date,
          description: "Spare parts for work order ##{find_work_order.service_number}",
          debit_amounts_attributes: [{  amount: order.total_cost,
                                        account: accounts_receivable},
                                      { amount: order.cost_of_goods_sold,
                                        account: cost_of_goods_sold } ],
            credit_amounts_attributes:[{amount: order.total_cost,
                                        account: sales},
                                       {amount: order.cost_of_goods_sold,
                                        account: merchandise_inventory}])
      end
      def find_customer
        Customer.find(customer_id)
      end
      def find_employee
        User.find(employee_id)
      end
      def find_cart
        Cart.find(cart_id)
      end
      def find_work_order
        WorkOrder.find(work_order_id)
      end
  end
end
