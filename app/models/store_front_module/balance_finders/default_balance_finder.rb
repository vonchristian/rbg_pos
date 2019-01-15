module StoreFrontModule
  module BalanceFinders
    class DefaultBalanceFinder
      attr_reader :line_items

      def initialize(args)
        @line_items = args.fetch(:line_items)
      end

      def compute
        line_items.with_orders.total_converted_quantity
      end
    end
  end
end
