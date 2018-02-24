module Uploads
  class PurchaseOrderLineItem
    include ActiveModel::Model
    attr_accessor :spreadsheet, :cart_id
    def process!
      ActiveRecord::Base.transaction do
        create_registry
      end
    end

    private
    def create_registry
      registry = Registry.create(spreadsheet: spreadsheet)
      parse_for_line_items(spreadsheet)
    end

    def parse_for_line_items(spreadsheet)
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      ActiveRecord::Base.transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            create_line_item(row)
          end
        end
      end
    end
    def find_cart
      Cart.find_by_id(cart_id)
    end
    def find_product(row)
      Product.find_by(name: row[4])
    end

    def create_line_item(row)
      find_cart.purchase_order_line_items.create!(
        quantity: row[0],
        unit_cost: row[1],
        total_cost: row[2],
        unit_of_measurement: find_product(row).unit_of_measurements.find_by(unit_code: row[3]),
        product: find_product(row),
        bar_code: row[5]

        )
    end
  end
end
