class Order < ApplicationRecord
  belongs_to :customer
  has_one :payment
  has_many :line_items, dependent: :destroy
  delegate :full_name, to: :customer, prefix: true
  delegate :total_cost, to: :payment, prefix: true, allow_nil: true
  delegate :mode_of_payment, :discount_amount, :cash?, to: :payment,  allow_nil: true

  before_validation :set_date
  accepts_nested_attributes_for :payment
  def add_line_items_from_cart(cart)
  	cart.line_items.each do |line_item|
  		line_item.cart_id = nil 
  		line_items << line_item
  	end 
  end 
  def total_cost 
  	line_items.sum(:total_cost)
  end
  def mode_of_payment_color
    if cash? 
      'success'
    else 
      'danger'
    end
  end
  private 
  def set_date 
  	self.date ||= Time.zone.now 
  end
end
