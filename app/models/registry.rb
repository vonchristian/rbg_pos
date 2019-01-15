class Registry < ApplicationRecord
  has_many :stocks, dependent: :destroy
  belongs_to :employee, class_name: "User"
	has_attached_file :spreadsheet, :path => ":rails_root/public/system/:attachment/:id/:filename"
  do_not_validate_attachment_file_type :spreadsheet
  has_many :line_items
  # after_create_commit :parse_for_records

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
    if find_product(row).blank?
      Product.find_or_create_by!(name: row[0], unit: row[1], category: create_or_find_category(row))
    end
  end
  def create_or_find_supplier(row)
  	Supplier.find_or_create_by!(business_name: row[8])
  end
  def create_or_find_stock(row)
    find_product(row).stocks.find_or_create_by!(date: self.created_at.strftime("%B %e, %Y"), registry: self, name: find_product(row).name,  barcode: normalized_barcode(row), quantity: row[3], unit_cost: row[4], total_cost: row[5], retail_price: row[6], wholesale_price: row[6], stock_type: row[7], supplier: create_or_find_supplier(row))
  end
  def normalized_barcode(row)
    if row[2].to_s.include?(".")
      row[2].to_s.chop.gsub(".", "")
    else
      row[2].to_s
    end
  end
  def create_or_find_category(row)
    Category.find_or_create_by(name: row[9])
  end
end
