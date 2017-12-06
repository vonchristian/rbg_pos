class Product < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:name]

	has_many :stocks, dependent: :destroy
	has_many :sold_items, through: :stocks, class_name: 'LineItem', source: :line_items
	has_many :orders, through: :sold_items
	has_many :sales_returns, through: :sold_items
	has_many :returned_items, through: :sold_items,  source: :sales_return #Sales Return
	has_many :items_under_warranty, through: :sales_returns, source: :warranty #forwarded items to supplier
	has_many :released_warranties, through: :items_under_warranty, source: :warranty_release


	has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/default_product_logo.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates :name, presence: true

  def self.low_on_stock
    all.select{ |a| a.low_on_stock? }
  end
  def self.out_of_stock
    all.select{ |a| a.out_of_stock? }
  end
  def self.most_bought
    all.to_a.sort_by(&:number_of_sold_items).reverse
  end
  def number_of_sold_items
    sold_items.count
  end
  def low_on_stock?
    !out_of_stock? && low_stock_count > in_stock
  end
  def out_of_stock?
    in_stock <= 0
  end
  def badge_color
    if out_of_stock?
      "danger"
    elsif low_on_stock?
      "warning"
    else
      "success"
    end
  end


  def self.import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      prod = find_by(id: row["id"]) || new
      member.attributes = row.to_hash
      member.save!
    end
  end

  def transferred_stocks
    orders.stock_transfers
  end

	def in_stock
		((delivered_items_count + returned_items_count) - (sold_items_count)) - released_warranties_count
	end
	def sold_items_count
		sold_items.sum(:quantity)
	end
	def delivered_items_count
		stocks.sum(:quantity)
	end
	def transferred_stocks_count
    if transferred_stocks.any?
		  transferred_stocks.sum(&:total_quantity)
    else
      0
    end
	end
	def returned_items_count
		returned_items.sum(:quantity)
	end
	def items_under_warranty_count
		items_under_warranty.sum(:quantity)
	end
	def released_warranties_count
		released_warranties.sum(:quantity)
	end
  def update_stocks_name
    stocks.each do |stock|
      stock.name = self.name
      stock.save
    end
  end
end
