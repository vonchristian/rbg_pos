class Stock < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:barcode, :name]
  enum stock_type: [:cash_purchase, :credit_purchase, :transferred, :old_stock]
  has_one :entry, as: :commercial_document, class_name: "AccountingModule::Entry", dependent: :destroy
  belongs_to :supplier, optional: true
  belongs_to :registry, optional: true
  belongs_to :employee, class_name: "User", foreign_key: 'employee_id', optional: true
  belongs_to :origin_branch, class_name: "Branch", foreign_key: 'origin_branch_id', optional: true
  belongs_to :product
  belongs_to :branch, optional: true
  has_many :line_items, dependent: :destroy
  has_many :orders, through: :line_items, source: :order
  has_many :work_orders, through: :line_items, source: :work_order
  has_many :sales_returns, through: :line_items
  has_many :stock_transfers, through: :line_items, source: :stock_transfer
  validates :quantity, :unit_cost, :total_cost, :retail_price, :wholesale_price, presence: true, numericality: true
  validates :product_id, presence: true

  delegate :name, :unit, :in_stock, to: :product, prefix: true, allow_nil: true
  delegate :avatar, to: :product, allow_nil: true
  delegate :business_name, to: :supplier, prefix: true, allow_nil: true
  delegate :category_name, to: :product
  before_validation :set_date
  after_create_commit :create_entry_for_stock
  after_commit :destroy_entry, on: :destroy
  def under_warranty?
    if quantity == 1
      line_items.map {|a| a.sales_return.present? }
    else
      false
    end
  end
  def badge_color
    if sold?
      'danger'
    else
      'success'
    end
  end

  def sold?
    orders.present?
  end
  def transferred?
    quantity==1 && stock_transfers.present?
  end
  def branch_destination
    if transferred?
      stock_transfers.last.destination_branch_name
    end
  end

  def customer_name
    if sold?
      line_items.map{|a| a.order.try(:customer_full_name) }.join(", ")
    end
  end

  def in_stock
    quantity - line_items.sum(&:quantity)  + sales_returns.sum(&:quantity)
  end

  def name_and_barcode
    "#{name} (#{barcode})"
  end
  def set_name
    self.name = self.product.name
    self.save
  end

  private
  def set_date
  	self.date ||= Time.zone.now
  end
  def destroy_entry
    entry.destroy
  end


  def create_entry_for_stock
    cash_on_hand = AccountingModule::Account.find_by(name: "Cash on Hand")
    accounts_payable = AccountingModule::Account.find_by(name: 'Accounts Payable-Trade')
    merchandise_inventory = AccountingModule::Account.find_by(name: "Merchandise Inventory")

    if cash_purchase?
      AccountingModule::Entry.create!(recorder_id: self.employee_id, entry_type: 'cash_stock', commercial_document: self, entry_date: self.date, description: "Cash Purchase of stocks", debit_amounts_attributes: [amount: self.total_cost, account: merchandise_inventory], credit_amounts_attributes:[amount: self.total_cost, account: cash_on_hand])
    elsif transferred? || credit_purchase? || old_stock?
      AccountingModule::Entry.create!(recorder_id: self.employee_id, entry_type: 'credit_stock', commercial_document: self, entry_date: self.date, description: "Credit/Transferred/Old  stocks", debit_amounts_attributes: [amount: self.total_cost, account: merchandise_inventory], credit_amounts_attributes:[amount: self.total_cost, account: accounts_payable])
    end
  end
end
