class WorkOrder < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:service_number, :reported_problem, :physical_condition, :customer_name, :product_name]
  multisearchable :against => [:description, :model_number, :serial_number,
    :updates_content, :reported_problem, :physical_condition, :service_number, :customer_name, :product_name]
  belongs_to :product_unit
  belongs_to :supplier, optional: true
  has_many :accessories
  belongs_to :customer, optional: true
  has_many :technician_work_orders, dependent: :destroy
  has_many :technicians, through: :technician_work_orders
  has_many :work_order_updates, as: :updateable, class_name: "Post", dependent: :destroy
  has_many :work_order_service_charges, dependent: :destroy
  has_many :service_charges, through: :work_order_service_charges
  has_many :spare_parts, class_name: "LineItem", foreign_key: 'work_order_id', dependent: :destroy
  has_many :accessories, dependent: :destroy
  enum status: [:received, :work_in_progress, :done, :released]
  accepts_nested_attributes_for :product_unit
  delegate :description, :model_number, :serial_number, to: :product_unit, allow_nil: true
  delegate :full_name, :address, :contact_number, to: :customer, allow_nil: true, prefix: true
  has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
  validates :description, :physical_condition, :reported_problem, presence: true
  validates :customer_id, presence: true
  after_commit :set_service_number, :set_customer_name, :set_product_name, on: [:create, :update]
  def self.from(hash={})
      if hash[:from_date] && hash[:to_date]
       from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date])
        to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date])
        where('created_at' => from_date..to_date)
      else
        all
      end
    end
  def self.payments
    select{ |a| a.payments }
  end
  def self.payments_total 
    all.sum(&:payments_total)
  end
  def accounts_receivable
    spare_parts = entries.work_order_credit.map{|a| a.debit_amounts.distinct.pluck(:amount).sum}.sum
    service_charges = entries.work_order_service_charge.map{|a| a.debit_amounts.distinct.pluck(:amount).sum}.sum
    spare_parts + service_charges
  end
  def payments
    entries.work_order_payment

  end

  def payments_total
    AccountingModule::Account.find_by_name('Accounts Receivables Trade - Current').credit_entries.where(commercial_document: self).distinct.pluck(:amount).sum - discounts_total
    # entries.work_order_payment.map{|a| a.debit_amounts.distinct.pluck(:amount).sum}.sum
  end
  def discounts_total
    AccountingModule::Account.find_by_name('Sales Discounts').debit_entries.where(commercial_document: self).distinct.pluck(:amount).sum
  end

  def balance_total
    accounts_receivable - discounts_total - payments_total
  end

  def updates_content
    work_order_updates.pluck(:content)
  end
  def total_spare_parts_cost
    spare_parts.total_cost
  end
  def total_service_charges_cost
    service_charges.sum(&:amount)
  end
  def total_charges_cost
    total_service_charges_cost + total_spare_parts_cost
  end
  def add_technician(technician)
    self.technician_work_orders.find_or_create_by(technician: technician)
  end
  def elapsed_time
    (self.created_at - Time.zone.now) /86400
  end
  
  def diagnoses
    work_order_updates.diagnosis
  end
  def actions_taken
    work_order_updates.actions_taken
  end
  def service_charge_entry(charge)
    service_fees = AccountingModule::Revenue.find_by(name: 'Service Fees')
    accounts_receivable = AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
    
    entries.work_order_service_charge.create(entry_date: charge.created_at,
      description: "#{charge.description}",
      user_id: charge.user_id,
      debit_amounts_attributes: [amount: charge.amount, account: accounts_receivable], 
      credit_amounts_attributes:[amount: charge.amount, account: service_fees])
  end
  def spare_part_entry(spare_part)
    cash_on_hand = AccountingModule::Account.find_by(name: "Cash on Hand (Cashier)")
    accounts_receivable = AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
    cost_of_goods_sold = AccountingModule::Account.find_by(name: "Cost of Goods Sold")
    sales = AccountingModule::Account.find_by(name: "Sales")
    merchandise_inventory = AccountingModule::Account.find_by(name: "Merchandise Inventory")


    entries.work_order_credit.create(entry_date: spare_part.created_at,
      description: "Spare parts installed", 
      user_id: spare_part.user_id, 
      debit_amounts_attributes: [{amount: spare_part.total_cost, account: accounts_receivable}, {amount: spare_part.total_cost, account: cost_of_goods_sold}], 
      credit_amounts_attributes:[{amount: spare_part.total_cost, account: sales}, {amount: spare_part.total_cost, account: merchandise_inventory}])
  end
  private
  def set_service_number
    self.service_number = nil
    self.service_number = self.id.to_s.rjust(12, '0')
  end
  def set_customer_name 
    self.customer_name = self.customer.full_name
  end
  def set_product_name 
    self.product_name = self.product_unit.description
  end
end
