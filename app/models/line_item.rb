class LineItem < ApplicationRecord
  belongs_to :cart
  belongs_to :stock
  belongs_to :order, optional: true
  
  delegate :barcode, :product_name, :product_unit, to: :stock
  validate :exceeds_available_stock?
  def unit_cost_and_quantity
  	unit_cost * quantity
  end
  private 
  def exceeds_available_stock?
    errors[:base] << "Exceeded available stock" if quantity > stock.product_in_stock
  end
end
