module StoreFrontModule
  module BalanceFinders
    class LineItemsStoreFrontToDate
      attr_reader :line_items, :store_front, :to_date, :from_date

      def initialize(args)
        @line_items  = args.fetch(:line_items)
        @store_front = args.fetch(:store_front)
        @to_date     = args.fetch(:to_date)
        @from_date   = args.fetch(:from_date, Date.current - 999.years)
      end

      def compute
        line_items.
        with_orders.
        for_store_front(store_front).
        entered_on(from_date: from_date, to_date: to_date).
        total_converted_quantity
      end
    end
  end
end
