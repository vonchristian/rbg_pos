module StoreFronts
  class StockTransferMigrator
    attr_reader :purchase_order_line_item

    def initialize(purchase_order_line_item:)
      @purchase_order_line_item = purchase_order_line_item
    end
    def migrate!
      purchase_order_line_item.stock_transfer_order_line_items.each do |line_item|
        if line_item.stock.blank?
          line_item.update!(stock: purchase_order_line_item.stock)
        end
      end
    end
  end
end 
