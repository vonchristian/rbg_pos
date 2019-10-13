module StoreFronts
  module StockTransfers
    class StockCreation
      attr_reader :line_item, :stock, :destination_store_front
      def initialize(line_item: line_item, destination_store_front:)
        @line_item               = line_item
        @destination_store_front = destination_store_front
        @stock                   = @line_item.stock
      end

      def create_stock!
        new_stock = destination_store_front.stocks.create!(
        available:           true,
        product:             line_item.product,
        unit_of_measurement: line_item.unit_of_measurement,
        barcode:              stock.barcode)

        line_item.update_attributes!(stock: new_stock)
      end
    end
  end
end
