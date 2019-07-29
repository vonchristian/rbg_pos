module StoreFronts
  class StockMigrator
    attr_reader :purchase_order_line_item, :order, :store_front

    def initialize(purchase_order_line_item:)
      @purchase_order_line_item = purchase_order_line_item
      @order       = @purchase_order_line_item.purchase_order
      @store_front = @order.store_front
    end

    def create_stock
      if purchase_order_line_item.stock.blank?
        stock = store_front.stocks.create!(
        product:     purchase_order_line_item.product,
        store_front: order.store_front,
        unit_of_measurement: purchase_order_line_item.unit_of_measurement,
        barcode:     purchase_order_line_item.bar_code)
        purchase_order_line_item.update_attributes!(stock: stock)
      end
    end
  end
end
