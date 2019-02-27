module StoreFrontModule
  module Orders
    class OtherSalesLineItemOrderProcessing
      include ActiveModel::Model
      attr_accessor :cart_id, :sales_order_id, :recorder_id, :date
      validates :date, :cart_id, :sales_order_id, :recorder_id, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_entry
          add_items
          remove_cart_reference
        end
      end

      private
      def add_items
        find_sales_order.other_sales_line_items << find_cart.other_sales_line_items
      end

      def create_entry
        store_front = find_employee.store_front
        accounts_receivable = store_front.receivable_account
        sales = store_front.sales_account
        AccountingModule::Entry.create!(
          recorder: find_employee,
          commercial_document: find_sales_order.customer,
          entry_date: date,
          description: "Other items added to sales order #{find_sales_order.reference_number}",
          debit_amounts_attributes: [ amount: find_cart.other_sales_line_items.total_cost,
                                      account: accounts_receivable,
                                      commercial_document: find_sales_order],


            credit_amounts_attributes:[ amount: find_cart.other_sales_line_items.total_cost,
                                        account: sales,
                                        commercial_document: find_sales_order])
      end
      def find_employee
        User.find(recorder_id)
      end
      def find_sales_order
        StoreFrontModule::Orders::SalesOrder.find(sales_order_id)
      end
      def find_cart
        Cart.find(cart_id)
      end
      def remove_cart_reference
        find_cart.other_sales_line_items.each do |line_item|
          line_item.cart_id = nil
          line_item.save!
        end
      end
    end
  end
end
