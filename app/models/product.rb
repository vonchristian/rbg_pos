class Product < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:name]

	has_many :stocks 
	has_many :sold_items, through: :stocks, class_name: 'LineItem', source: :line_items
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
		deliveries - sold
	end 
	def sold 
		sold_items.sum(:quantity)
	end
	def deliveries
		stocks.sum(:quantity)
	end
end
