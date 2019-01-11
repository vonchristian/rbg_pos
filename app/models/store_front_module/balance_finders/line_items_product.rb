module StoreFrontModule
  module BalanceFinders
    class LineItemsProduct
    attr_reader :product

    def post_initialize(args)
      @product    = args.fetch(:product)
    end

    def compute
      line_items.
      with_orders.
      where(product: product).
      total_converted_quantity
    end
  end
end
