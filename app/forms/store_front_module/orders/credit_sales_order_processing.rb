module StoreFrontModule
  module Orders
    class CreditSalesOrderProcessing
      include ActiveModel::Model
      attr_accessor  :customer_id,
                     :date,
                     :description,
                     :employee_id,
                     :cart_id,
                     :store_front_id,
                     :account_number,
                     :reference_number

      validates :cart_id,
      :employee_id,
      :customer_id,
      :date,
      :reference_number,
      presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_receivable_account
          create_sales_order
        end
      end
       def find_cart
        Cart.find_by(id: cart_id)
      end
      private
      def create_receivable_account
        AccountingModule::Asset.create!(
          business:     find_employee.business,
          account_code: SecureRandom.uuid,
          name:         account_name
        )
      end

      def create_sales_order
          order = StoreFrontModule::Orders::SalesOrder.create!(
          store_front_id: store_front_id,
          account_number: account_number,
          date: date,
          employee: find_employee,
          commercial_document: find_customer,
          description: description,
          search_term: find_customer.name,
          reference_number: reference_number,
          receivable_account_id: AccountingModule::Asset.find_by!(name: account_name).id)

          find_cart.sales_order_line_items.each do |sales_order_line_item|
            sales_order_line_item.update_attributes!(date: date)
            sales_order_line_item.cart_id = nil
            order.sales_order_line_items << sales_order_line_item

        end
        create_entry(order)
      end
      def find_customer
        Customer.find(customer_id)
      end

      def find_employee
        User.find(employee_id)
      end

      def account_name
        "Accounts Receivable - #{find_customer.full_name}, #{account_number}"
      end

      def create_entry(order)
        store_front = find_employee.store_front
        accounts_receivable = order.receivable_account
        cost_of_goods_sold = store_front.cost_of_goods_sold_account
        sales = store_front.sales_account
        sales_discount = store_front.sales_discount_account
        merchandise_inventory = store_front.merchandise_inventory_account
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_customer,
          entry_date: order.date,
          description: "Credit sales",
          debit_amounts_attributes: [{ amount: order.total_cost,
                                        account: accounts_receivable,
                                        commercial_document: order},
                                      { amount: order.cost_of_goods_sold,
                                        account: cost_of_goods_sold,
                                        commercial_document: order } ],
            credit_amounts_attributes:[{amount: order.total_cost,
                                        account: sales,
                                        commercial_document: order},
                                       { amount: order.cost_of_goods_sold,
                                        account: merchandise_inventory,
                                        commercial_document: order}])
      end
    end
  end
end
