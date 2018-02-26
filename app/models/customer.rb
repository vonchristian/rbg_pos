class Customer < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:first_name, :last_name, :contact_number, :address]
  multisearchable against: [:first_name, :last_name]
	has_many :orders, as: :commercial_document
  has_many :repair_service_orders, class_name: "RepairServicesModule::RepairServiceOrder", as: :commercial_document
	has_many :entries, through: :orders
  has_many :payments, as: :commercial_document, class_name: "AccountingModule::Entry"
	has_many :line_items, through: :orders
  has_many :work_orders
  has_many :sales_orders, class_name: "StoreFrontModule::Orders::SalesOrder", as: :commercial_document
	has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates :first_name, :last_name, :contact_number, presence: true
  scope :recent, ->(num) { order('created_at DESC').limit(num) }

  def work_order_payments

  end
	def self.with_credits
    all.select{ |a| a.with_credits? }
  end
  def last_updated_at
    if line_items.present?
      line_items.last.created_at
    else
      created_at
    end
  end
  def name
    full_name
  end
  def full_name
		"#{first_name} #{last_name}"
	end
	def purchases_count
		orders.count
	end

	def accounts_receivable
    other_credits_total +
    credit_sales_order_accounts_receivable_total +
    credit_repair_services_accounts_receivable_total
	end

  def credit_sales_order_accounts_receivable_total
    total = []
    sales_orders.each do |order|
      total << StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.debits_balance(commercial_document_id: order.id)
    end
    total.sum
  end
  def other_credits_total
    StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.debits_balance(commercial_document_id: self.id)
  end
  def other_credits
    StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.debit_entries.where(commercial_document_id: self.id)
  end


  def credit_repair_services_accounts_receivable_total
    total = []
    work_orders.each do |order|
      total << StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.debits_balance(commercial_document_id: order.id)
    end
    total.sum
  end

  def payments_total
    credit_sales_order_payments_total +
    credit_repair_services_payments_total
  end

  def credit_sales_order_payments_total
    total = []
    sales_orders.each do |order|
      total << StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.credits_balance(commercial_document_id: order.id)
    end
    total.sum
  end

  def credit_repair_services_payments_total
    total = []
    work_orders.each do |order|
      total << StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.credits_balance(commercial_document_id: order.id)
    end
    total.sum
  end

  def balance_total
    accounts_receivable - payments_total
  end

  def with_credits?
    balance_total > 0
  end

  def payment_entries
    StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.credit_entries.where(commercial_document: self)
  end


end
