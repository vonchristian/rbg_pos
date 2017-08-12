class Product < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:name]

	has_many :stocks 
	has_many :sold_items, through: :stocks, class_name: 'LineItem', source: :line_items
	has_many :returned_items, through: :sold_items,  source: :sales_return
	has_many :items_under_warranty, through: :sold_items, source: :sales_return

	has_many :transferred_stocks, through: :stocks, source: :stock_transfers
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
  validates :name, presence: true, uniqueness: true
	def in_stock
		(delivered_items_count + returned_items_count) - (sold_items_count - transferred_stocks_count)
	end 
	def sold_items_count
		sold_items.sum(:quantity)
	end
	def delivered_items_count
		stocks.sum(:quantity)
	end
	def transferred_stocks_count
		transferred_stocks.sum(:quantity)
	end
	def returned_items_count 
		returned_items.sum(:quantity)
	end
	def items_under_warranty_count
		items_under_warranty.sum(:quantity)
	end
end
