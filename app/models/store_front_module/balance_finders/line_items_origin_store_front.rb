module StoreFrontModule
  module BalanceFinders
    class LineItemsOriginStoreFront
      attr_reader :origin_store_front, :line_items

      def initialize(args)
        @line_items = args.fetch(:line_items)
        @origin_store_front = args.fetch(:origin_store_front)
      end

      def compute
        line_items.
        with_orders.
        includes(:order).
        where('orders.store_front_id' => origin_store_front.id).
        total_converted_quantity
      end
    end
  end
end
