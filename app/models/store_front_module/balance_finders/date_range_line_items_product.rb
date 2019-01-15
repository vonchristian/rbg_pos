module StoreFrontModule
  module BalanceFinders
    class DateRangeLineItemsProduct
      attr_reader :date_range, :product, :line_items

      def post_initialize(args)
        @line_items = args.fetch(:line_items)
        @product    = args.fecth(:product)
        @date_range = args.fecth(:date_range)
      end

      def compute
        line_items.
        with_orders.
        where('created_at' => date_range).
        where(product: product).
        total_converted_quantity
      end
    end
  end
end
