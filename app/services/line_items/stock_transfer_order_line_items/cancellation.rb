
  module LineItems
    module StockTransferOrderLineItems
      class Cancellation
        attr_reader :line_item, :employee

        def initialize(args)
          @line_item = args.fetch(:line_item)
          @employee = args.fetch(:employee)
        end
        def cancel!
          line_item.stock_transfer_order_line_items.destroy_all
          line_item.destroy
        end
      end
    end
end
