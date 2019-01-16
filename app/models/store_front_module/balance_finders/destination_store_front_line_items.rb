module StoreFrontModule
  module BalanceFinders
    class DestinationStoreFrontLineItems
      attr_reader :destination_store_front, :line_items

      def initialize(args)
        @line_items = args.fetch(:line_items)
        @destination_store_front = args.fetch(:destination_store_front)
      end

      def compute
        line_items.
        with_orders.
        includes(:order).
        where('orders.destination_store_front_id' => destination_store_front.id).
        total_converted_quantity
      end
    end
  end
end
