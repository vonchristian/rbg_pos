module Orders
  module SalesOrders
    module OtherSalesLineItems
      class Cancellation
        attr_reader :other_sales_line_item, :order, :employee

        def initialize(args)
          @employee              = args.fetch(:employee)
          @other_sales_line_item = args.fetch(:other_sales_line_item)
          @order                 = @other_sales_line_item.order
        end

        def cancel!
          ActiveRecord::Base.transaction do
            create_entry
            delete_item
          end
        end

        def create_entry
          store_front           = order.store_front
          accounts_receivable   = order.receivable_account
          cost_of_goods_sold    = store_front.cost_of_goods_sold_account
          sales                 = order.sales_revenue_account
          sales_discount        = order.default_sales_discount_account
          merchandise_inventory = store_front.merchandise_inventory_account
          employee.entries.create!(
            commercial_document: order.customer,
            entry_date: Date.current,
            description: "Sales Return - #{order.account_number}",
            credit_amounts_attributes: [amount: other_sales_line_item.amount,
                                          account: credit_account
                                         ],
              debit_amounts_attributes:[amount: other_sales_line_item.amount,
                                          account: sales
                                         ])
        end

        def delete_item
          other_sales_line_item.destroy
        end

       

        def credit_account
          if order.receivable_account.balance.zero?
            order.employee.cash_on_hand_account
          else
            order.receivable_account
          end
        end
      end
    end
  end
end
