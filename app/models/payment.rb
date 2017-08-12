class Payment < ApplicationRecord
	enum mode_of_payment: [:cash, :credit, :stock_transfer]
  belongs_to :order
end
