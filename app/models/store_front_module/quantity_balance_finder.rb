module StoreFrontModule
  module QuantityBalanceFinder
    def balance(options={})
      if options[:from_date].present? && options[:to_date].present?
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        joins(:order).where.not(order_id: nil).where('orders.date' => (date_range.start_date)..(date_range.end_date)).sum(&:converted_quantity)
      elsif options[:product_id].present?
        joins(:product).where.not(order_id: nil).where('product_id' => options[:product_id]).sum(&:converted_quantity)
      else
        joins(:order).where.not(order_id: nil).sum(&:converted_quantity)
      end
    end
  end
end
