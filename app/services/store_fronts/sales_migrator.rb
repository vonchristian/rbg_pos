module StoreFronts
  class SalesMigrator
    attr_reader :sales_order_line_items

    def initialize(sales_order_line_items:)
      @sales_order_line_items = sales_order_line_items
    end

    def migrate_sales!
      sales_order_line_items.each do |line_item|
        # if line_item.stock.blank? && line_item.purchase_order_line_items.count == 1
          line_item.update_attributes!(stock: line_item.purchase_order_line_items.last.stock)
        # end
      end
    end
  end
end
