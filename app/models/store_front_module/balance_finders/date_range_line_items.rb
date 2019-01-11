module StoreFrontModule
  module BalanceFinders
    class DateRangeLineItems < DefaultBalanceFinder
      attr_reader :date_range

      def post_initialize(args)
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
