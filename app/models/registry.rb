class Registry < ApplicationRecord
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
          create_or_find_product(row)
          create_or_find_supplier(row)
          create_or_find_stock(row)
        end
      end
    end
  end
  def find_product(row)
    Product.find_by(name: row[0], unit: row[1])
  end
  def create_or_find_product(row)
    Product.find_or_create_by(name: row[0], unit: row[1])
  end
  def create_or_find_supplier(row)
  	Supplier.find_or_create_by(business_name: row[8])
  end
  def create_or_find_stock(row)
    if find_product(row).present?
      find_product(row).stocks.create!(name: row[0], barcode: row[2].to_s, quantity: row[3], unit_cost: row[4], total_cost: row[5], retail_price: row[6], wholesale_price: row[6], stock_type: row[7], supplier: create_or_find_supplier(row))
    end
  end
end
