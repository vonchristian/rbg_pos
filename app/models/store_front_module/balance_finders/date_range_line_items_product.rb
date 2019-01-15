module StoreFrontModule
  module BalanceFinders
    class DateRangeLineItemsProduct < DefaultBalanceFinder
      attr_reader :date_range, :product

      def post_initialize(args)
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
