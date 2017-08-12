class Supplier < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:business_name, :owner_name, :contact_number]
	validates :business_name,  :contact_number, presence: true
end
