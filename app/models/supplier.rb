class Supplier < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:business_name, :owner_name, :contact_number]
	validates :business_name, presence: true
	has_many :delivered_stocks, class_name: "Stock"
	has_many :entries, through: :delivered_stocks
  has_many :payments, as: :commercial_document, class_name: "AccountingModule::Entry"
	
  def accounts_payable
		entries.credit_stock.all.map{|a| a.debit_amounts.pluck(:amount).sum }.sum
	end
  
  def payments_total
    payments.supplier_credit_payment.map{|a| a.debit_amounts.distinct.pluck(:amount).sum}.sum
  end
  def balance_total
    accounts_payable - payments_total
  end
end
