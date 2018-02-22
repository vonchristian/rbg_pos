class Customer < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:first_name, :last_name, :contact_number, :address]
	has_many :orders
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
    credit_orders_receivables +
    work_orders_accounts_receivables
	end
  def credit_orders_receivables
    StoreFrontModule::StoreFrontConfig.default_accounts_receivable_account.balance(commercial_document_id: self.id)
  end
  def work_orders_accounts_receivables
    work_orders.sum(&:accounts_receivable)
  end
  def payments_total
    payments.customer_credit_payment.map{|a| a.debit_amounts.distinct.pluck(:amount).sum}.sum +
    work_orders.payments_total
  end
  def balance_total
    accounts_receivable - payments_total
  end
  def with_credits?
    balance_total > 0
  end

end
