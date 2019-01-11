module StoreFrontModule
  module BalanceFinders
    class LineItemsProduct
    attr_reader :product, :to_date

    def post_initialize(args)
      @product    = args.fetch(:product)
      @to_date    = args.fetch(:to_date)
      @from_date  = 999.years.ago
    end

    def compute
      line_items.
      with_orders.
      where(product: product).
      where('created_at' => date_range.new).
      total_converted_quantity
    end
    
    def date_range
      DateRange.new(from_date: from_date, to_date: to_date)
    end
  end
end
