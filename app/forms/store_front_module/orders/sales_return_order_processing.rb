module StoreFrontModule
  module Orders
    class SalesReturnOrderProcessing
      include ActiveModel::Model
      include ActiveModel::Validations
      attr_accessor  :customer_id,
                     :date,
                     :employee_id,
                     :cart_id,
                     :description,
                     :reference_number

      validates :cart_id,
      :employee_id,
      :customer_id,
      :description,
      :date,
      presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_sales_order
        end
      end
       def find_cart
        Cart.find_by(id: cart_id)
      end
      private
      def create_sales_order
        order = StoreFrontModule::Orders::SalesReturnOrder.create!(
        date: date,
        store_front: find_employee.store_front,
        employee: find_employee,
        account_number: SecureRandom.uuid,
        commercial_document: find_customer,
        search_term: find_customer.name,
        reference_number: reference_number)
        find_cart.sales_return_order_line_items.each do |line_item|
          line_item.update!(date: date)
          line_item.cart_id = nil
          line_item.save
          order.sales_return_order_line_items << line_item
        end
        create_voucher(order)
        create_entry(order)
      end

      def find_customer
        Customer.find(customer_id)
      end

      def find_employee
        User.find(employee_id)
      end

      def create_voucher(order)
        Vouchers::SalesOrderVoucher.new(order: order, employee: find_employee).create_voucher!
      end

      def create_entry(order)
        VoucherEntryCreation.new(voucher: order.voucher).create_entry!
      end


      # def create_entry(order)
      #   store_front = find_employee.store_front
      #   cash_on_hand = find_employee.cash_on_hand_account
      #   sales_returns = store_front.sales_return_account
      #   cost_of_goods_sold = store_front.cost_of_goods_sold_account
      #   merchandise_inventory = store_front.merchandise_inventory_account
      #   find_employee.entries.create!(
      #     recorder: find_employee,
      #     commercial_document: find_customer,
      #     entry_date: order.date,
      #     description: description,
      #     credit_amounts_attributes: [{ amount: order.total_cost,
      #                                   account: cash_on_hand,
      #                                   commercial_document: order},
      #                                 { amount: order.total_cost,
      #                                   account: cost_of_goods_sold,
      #                                   commercial_document: order } ],
      #       debit_amounts_attributes:[{amount: order.total_cost,
      #                                   account: merchandise_inventory,
      #                                   commercial_document: order},
      #                                  {amount: order.total_cost,
      #                                   account: sales_returns,
      #                                   commercial_document: order}])
      # end
    end
  end
end
