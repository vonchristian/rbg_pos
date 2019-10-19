
  module LineItems
    module StockTransferOrderLineItems
      class Cancellation
        attr_reader :line_item, :stock, :order,  :employee

        def initialize(args)
          @line_item = args.fetch(:line_item)
          @order     = StoreFrontModule::Orders::PurchaseOrder.find(@line_item.order_id)
          @stock     = @line_item.stock
        end

        def cancel!
          ActiveRecord::Base.transaction do
            delete_stock_transfers
            delete_line_item
          end
        end

        def delete_stock_transfers
          ids = order.stock_transfer_order_line_items.pluck(:stock_id)
          order.store_front.stocks.where(id: ids.uniq.compact.flatten).each do |stock|
          stock.stock_transfers.where(order: order).destroy_all
        end
        def delete_line_item
          line_item.destroy
        end
      end
    end
  end
end
