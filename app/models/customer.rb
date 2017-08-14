class Customer < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:first_name, :last_name, :contact_number, :address]
	has_many :orders
	has_many :entries, through: :orders
	has_many :line_items, through: :orders
	has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates :first_name, :last_name, :contact_number, presence: true
	def full_name 
		"#{first_name} #{last_name}"
	end
	def purchases_count
		orders.count
	end
	def accounts_receivable
    entries.credit_order.map{|a| a.debit_amounts.pluck(:amount).sum}.sum
	end
end
