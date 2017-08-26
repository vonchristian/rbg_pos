class Order < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :branch, optional: true

  has_one :payment
  has_one :entry, as: :commercial_document, class_name: "AccountingModule::Entry"
  has_many :line_items, dependent: :destroy
  delegate :full_name, to: :customer, prefix: true
  delegate :total_cost, to: :payment, prefix: true, allow_nil: true
  delegate :mode_of_payment, :discount_amount, :stock_transfer?, :credit?, :cash?, :total_cost, :total_cost_less_discount, to: :payment,  allow_nil: true
  before_validation :set_date
  accepts_nested_attributes_for :payment

  after_create_commit :create_entry_for_order
  def self.created_between(hash={})
    if hash[:from_date] && hash[:to_date]
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
      where('date' => from_date..to_date)
    else
      all
    end
  end
  def line_items_total_cost
    line_items.sum(:total_cost)
  end
  def add_line_items_from_cart(cart)
  	cart.line_items.each do |line_item|
  		line_item.cart_id = nil 
  		self.line_items << line_item
  	end 
  end 
  
  def discounted?
  	payment && payment.discount_amount.present? && discount_amount > 0
  end
  
  def mode_of_payment_color
    if cash? 
      'success'
    else 
      'danger'
    end
  end
  def stock_cost
    line_items.sum(&:unit_cost_and_quantity)
  end

  private 
  def set_date 
  	self.date ||= Time.zone.now 
  end
  def create_entry_for_order
  	cash_on_hand = AccountingModule::Account.find_by(name: "Cash on Hand (Cashier)")
  	accounts_receivable = AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
  	cost_of_goods_sold = AccountingModule::Account.find_by(name: "Cost of Goods Sold")
  	sales = AccountingModule::Account.find_by(name: "Sales")
  	merchandise_inventory = AccountingModule::Account.find_by(name: "Merchandise Inventory")
    if cash?
      AccountingModule::Entry.create!(entry_type: 'cash_order', commercial_document: self, entry_date: self.date, description: "Payment for order", 
      	debit_amounts_attributes: [{amount: self.total_cost_less_discount, account: cash_on_hand}, {amount: self.stock_cost, account: cost_of_goods_sold}], 
      	credit_amounts_attributes:[{amount: self.total_cost_less_discount, account: sales}, {amount: self.stock_cost, account: merchandise_inventory}])
    elsif credit? || stock_transfer?
      AccountingModule::Entry.create!(entry_type: 'credit_order', commercial_document: self, entry_date: self.date, description: "Credit order", 
        debit_amounts_attributes: [{amount: self.total_cost_less_discount, account: accounts_receivable}, {amount: self.stock_cost, account: cost_of_goods_sold}], 
        credit_amounts_attributes:[{amount: self.total_cost_less_discount, account: sales}, {amount: self.stock_cost, account: merchandise_inventory}])
    end
  end
end
