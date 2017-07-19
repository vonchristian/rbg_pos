class Payment < ApplicationRecord
	enum mode_of_payment: [:cash, :credit]
  belongs_to :order
end
