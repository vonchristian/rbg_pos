class StockTransfer < ApplicationRecord
  belongs_to :destination_branch, class_name: "Branch", foreign_key: 'destination_branch_id', optional: true
  belongs_to :origin_branch, class_name: "Branch", foreign_key: 'destination_branch_id'
  belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
  has_one :entry, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
  has_many :line_items, foreign_key: 'stock_transfer_id', dependent: :destroy
  validates :date, presence: true
  before_validation :set_default_date
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |line_item|
      line_item.cart_id = nil 
      self.line_items << line_item
    end 
  end 
  def total_cost 
    line_items.total_cost
  end
  def create_entry
    cost_of_goods_sold = AccountingModule::Account.find_by(name: "Cost of Goods Sold")
    merchandise_inventory = AccountingModule::Account.find_by(name: "Merchandise Inventory")
      AccountingModule::Entry.stock_transfer.create!(recorder_id: self.employee_id, commercial_document: self, entry_date: self.date, description: "Stock transfer", 
        debit_amounts_attributes: [amount: self.total_cost, account: cost_of_goods_sold], 
        credit_amounts_attributes:[amount: self.total_cost, account: merchandise_inventory])
  end

  private 
  def set_default_date 
  	self.date ||= Time.zone.now 
  end
end
