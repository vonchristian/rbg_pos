class Supplier < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:business_name, :owner_name, :contact_number]
	validates :business_name, presence: true
	has_many :delivered_stocks, class_name: "Stock"
	has_many :entries, through: :delivered_stocks
  has_many :payments, as: :commercial_document, class_name: "AccountingModule::Entry"

  has_many :purchase_orders, class_name: "StoreFrontModule::Orders::PurchaseOrder", as: :commercial_document
  has_many :vouchers, as: :payee
  has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", as: :commercial_document
  def name
    business_name
  end
  def accounts_payable
		entries.credit_stock.all.map{|a| a.debit_amounts.pluck(:amount).sum }.sum
	end
  def temporary_voucher_amounts
    voucher_amounts.where(voucher_id: nil)
  end

  def payments_total
    payments.supplier_credit_payment.map{|a| a.debit_amounts.distinct.pluck(:amount).sum}.sum
  end
  def balance_total
    accounts_payable - payments_total
  end
end
