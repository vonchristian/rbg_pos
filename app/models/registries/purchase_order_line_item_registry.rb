module Registries
  class PurchaseOrderLineItemRegistry < Registry
    has_attached_file :spreadsheet, :path => ":rails_root/public/system/:attachment/:id/:filename"
    do_not_validate_attachment_file_type :spreadsheet

    after_create_commit :parse_for_records

    private
    def parse_for_records
      book = Spreadsheet.open(spreadsheet.path)
      sheet = book.worksheet(0)
      transaction do
        sheet.each 1 do |row|
          if !row[0].nil?
            create_or_find_line_item(row)
          end
        end
      end
    end

    def create_or_line_item(row)
      transfer = StoreFrontModule::LineItems::PurchaseOrderLineItem.find_or_create_by(
        quantity: quantity(row),
        unit_cost: unit_cost(row),
        total_cost: total_cost(row),
        product: product(row),
        unit_of_measurement: unit_of_measurement(row),
        bar_code: bar_code(row))
    end

    def quantity(row)
      row[3]
    end

    def unit_cost(row)
      row[4]
    end

    def total_cost(row)
      row(5)
    end

    def product(row)
      Product.find_or_create_by(name: row[0])
    end

    def unit_of_measurement(row)
      product(row).unit_of_measurements.find_or_create_by(
        unit_code: row[2],
        base_measurement: row[7],
        converted_quantity: row[8],
        quantity: row[9]
        )
    end
  end
end
