class SalesReturn < ApplicationRecord
  belongs_to :line_item, optional: true
  belongs_to :order, optional: true
  has_one :warranty, dependent: :destroy
  has_one :warranty_release, through: :warranty
  enum sales_return_type: [:for_warranty, :refund_payment, :return_to_stock]
  
  validates :remarks, presence: true
  validate :quantity_is_less_than_or_equal_to_line_item_quantity
  before_validation :set_default_date
  after_commit :create_warranty
  
  def quantity_is_less_than_or_equal_to_line_item_quantity
    errors[:quantity] << "Quantity must be equal or less than item quantity" if self.quantity > line_item.quantity
  end

  private 
  def set_default_date 
  	self.date ||= Time.zone.now 
  end 
  def create_warranty
  	if for_warranty?
  		self.create_warranty!(customer: self.line_item.order.customer, remarks: self.remarks, date: self.date, quantity: self.quantity, name: self.line_item.stock.name, barcode: self.line_item.stock.barcode)
  	end 
  end 
end
