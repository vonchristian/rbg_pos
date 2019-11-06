module StoreFronts
  module Orders
    module SalesOrders
      class Cancellation
        attr_reader :sales_order, :voucher, :receivable_account, :sales_revenue_account

        def initialize(sales_order:)
          @sales_order           = sales_order
          @voucher               = @sales_order.voucher
          @receivable_account    = @sales_order.receivable_account
          @sales_revenue_account = @sales_order.sales_revenue_account
        end

        def cancel!
          ActiveRecord::Base.transaction do
            delete_entry!
            delete_line_items!
            delete_order!
            delete_accounts!
            delete_voucher!
          end
        end

        private
        def delete_accounts!
          receivable_account.entries.destroy_all
          sales_revenue_account.entries.destroy_all
          receivable_account.destroy
          sales_revenue_account.destroy
        end
        def delete_entry!
          voucher.entry.destroy
        end
        def delete_line_items!
          sales_order.sales_order_line_items.destroy_all
        end

        def delete_order!
          sales_order.destroy
        end

        def delete_voucher!
          voucher.destroy
        end
      end
    end
  end
end
