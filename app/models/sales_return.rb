class SalesReturn < ApplicationRecord
  belongs_to :line_item, optional: true
  belongs_to :order, optional: true
  enum sales_return_type: [:for_warranty, :refund_payment]
  
  validates :remarks, presence: true
  validate :quantity_is_less_than_or_equal_to_line_item_quantity
  before_validation :set_default_date
  def quantity_is_less_than_or_equal_to_line_item_quantity
    errors[:quantity] << "Quantity must be equal or less than item quantity" if self.quantity > line_item.quantity
  end

  private 
  def set_default_date 
  	self.date ||= Time.zone.now 
  end 
end
