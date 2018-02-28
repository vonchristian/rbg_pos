module StoreFrontModule
  module Registries
    class StockTransferRegistry < Registry
      has_many :received_stock_transfer_order_line_items, class_name: "StoreFrontModule::LineItems::ReceivedStockTransferOrderLineItem", foreign_key: 'registry_id'

      def parse_for_records
        book = Spreadsheet.open(spreadsheet.path)
        sheet = book.worksheet(0)
        transaction do
          sheet.each 1 do |row|
            if !row[0].nil?
              create_or_find_product(row)
              create_or_find_received_stock_transfer_line_item(row)
              find_or_create_selling_price(row)
            end
          end
        end
      end
      private
      def create_or_find_product(row)
        Product.find_or_create_by(name: row[0])
      end

      def create_or_find_received_stock_transfer_line_item(row)
        find_product(row).received_stock_transfers.create(
          quantity: row[3],
          unit_cost: row[4],
          total_cost: row[5],
          unit_of_measurement: find_or_create_unit_of_measurement(row),
          bar_code: row[2],
          registry_id: self.id
          )
      end

      def find_or_create_unit_of_measurement(row)
        find_product(row).unit_of_measurements.find_or_create_by(
          unit_code: row[1],
          base_measurement: row[7],
          conversion_quantity: row[8],
          quantity: row[9]
          )
      end
      def find_or_create_selling_price(row)
        find_product(row).selling_prices.create(price: row[6], unit_of_measurement: find_unit_of_measurement(row))
      end
      def find_product(row)
        Product.find_by(name: row[0])
      end
      def find_unit_of_measurement(row)
        find_product(row).unit_of_measurements.find_by(unit_code: row[1], base_measurement: row[7], conversion_quantity: row[8], quantity: row[9])
      end
    end
  end
end
