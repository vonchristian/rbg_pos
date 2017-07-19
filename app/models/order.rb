class Order < ApplicationRecord
  belongs_to :customer
  has_one :payment
  has_many :line_items, dependent: :destroy
  delegate :full_name, to: :customer, prefix: true
  delegate :total_cost, to: :payment, prefix: true, allow_nil: true
  delegate :mode_of_payment, :discount_amount, :cash?, :total_cost_less_discount, to: :payment,  allow_nil: true

  before_validation :set_date
  accepts_nested_attributes_for :payment
  def self.created_between(hash={})
    if hash[:from_date] && hash[:to_date]
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
      where('date' => from_date..to_date)
    else
      all
    end
  end
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
