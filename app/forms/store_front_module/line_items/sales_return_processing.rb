module StoreFrontModule
  module LineItems
    class SalesReturnProcessing
      include ActiveModel::Model
      attr_accessor :sales_order_line_item_id, :quantity, :employee_id, :date


      def process!
        if valid?
          ActiveRecord::Base.transaction do
            update_sales_order_line_item
            create_entry
          end
        end
      end

      private
      def update_sales_order_line_item
        find_sales_order_line_item.update!(
          quantity: remaining_quantity,
          total_cost: total_cost)
      end

      def remaining_quantity
        find_sales_order_line_item.quantity - quantity.to_f
      end

      def total_cost
        find_sales_order_line_item.unit_cost * remaining_quantity
      end
      def cost_for_return
        quantity.to_f * find_sales_order_line_item.unit_cost
      end
      def find_sales_order_line_item
        StoreFrontModule::LineItems::SalesOrderLineItem.find(sales_order_line_item_id)
      end

      def order
        find_sales_order_line_item.sales_order
      end

      def create_entry
        if order.receivable_account.present?
          create_entry_for_credit_sale
        end
      end
      def find_employee
        User.find(employee_id)
      end
      def create_entry_for_credit_sale
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: order.customer,
          entry_date: order.date,
          description: "Credit sales return",
          debit_amounts_attributes: [   amount: cost_for_return,
                                        account: order.sales_revenue_account,
                                        commercial_document: order
                                      ],
            credit_amounts_attributes:[ amount: cost_for_return,
                                        account: order.receivable_account,
                                        commercial_document: order
                                       ])
      end
    end
  end
end
