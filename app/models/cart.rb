class Cart < ApplicationRecord
	has_many :line_items, dependent: :destroy
	def total_cost 
		line_items.sum(:total_cost)
	end
end
