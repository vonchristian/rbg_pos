module StoreFrontModule
  module BalanceFinders
    class DateRangeLineItems
      attr_reader :date_range

      def post_initialize(args)
        @line_items = args.fetch(:line_items)
        @date_range = args.fecth(:date_range)
      end

      def compute
        line_items.
        with_orders.
        where('created_at' => date_range).
        total_converted_quantity
      end
    end
  end
end
