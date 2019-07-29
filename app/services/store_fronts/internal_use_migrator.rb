module StoreFronts
  class InternalUseMigrator
    attr_reader :internal_use_order_line_items

    def initialize(internal_use_order_line_items:)
      @internal_use_order_line_items = internal_use_order_line_items
    end

    def migrate!
      internal_use_order_line_items.each do |line_item|
        if line_item.stock.blank? && line_item.purchase_order_line_items.count == 1
          line_item.update_attributes!(stock: line_item.purchase_order_line_items.last.stock)
        end
      end
    end
  end
end
