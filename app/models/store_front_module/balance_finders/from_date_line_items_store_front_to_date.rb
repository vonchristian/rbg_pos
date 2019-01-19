module StoreFrontModule
  module BalanceFinders
    class FromDateLineItemsStoreFrontToDate
      attr_reader :line_items, :store_front, :to_date, :from_date

      def initialize(args)
        @line_items  = args.fetch(:line_items)
        @store_front = args.fetch(:store_front)
        @to_date     = args.fetch(:to_date)
        @from_date   = args.fetch(:from_date)
      end

      def compute
        line_items.
        for_store_front(store_front).
        entered_on(from_date: from_date, to_date: to_date).
        with_orders.
        total_converted_quantity
      end
    end
  end
end
