module Orders
  module SalesOrders
    module SalesOrderLineItems
      class Cancellation
        attr_reader :line_item, :order, :employee

        def initialize(args)
          @employee  = args.fetch(:employee)
          @line_item = args.fetch(:line_item)
          @order     = @line_item.sales_order
        end
        def cancel!
          create_entry
          delete_item
        end

        def create_entry
          store_front = employee.store_front
          accounts_receivable = order.default_receivable_account
          cost_of_goods_sold = store_front.cost_of_goods_sold_account
          sales = order.default_sales_revenue_account
          sales_discount = order.default_sales_discount_account
          merchandise_inventory = store_front.merchandise_inventory_account
          employee.entries.create!(
            commercial_document: order.customer,
            entry_date: Date.current,
            description: "Sales Return - #{order.account_number}",
            credit_amounts_attributes: [{ amount: line_item.total_cost,
                                          account: credit_account,
                                          commercial_document: order},
                                        { amount: line_item.cost_of_goods_sold,
                                          account: cost_of_goods_sold,
                                          commercial_document: order} ],
              debit_amounts_attributes:[{amount: line_item.total_cost,
                                          account: sales,
                                          commercial_document: order},
                                         { amount: line_item.cost_of_goods_sold,
                                          account: merchandise_inventory,
                                          commercial_document: order}])
        end

        def delete_item
          line_item.referenced_purchase_order_line_items.destroy_all
          line_item.destroy
        end

        def credit_account
          if order.receivable_account.amounts.where(commercial_document: order).blank?
            order.employee.cash_on_hand_account
          else
            order.default_receivable_account
          end
        end
      end
    end
  end
end
