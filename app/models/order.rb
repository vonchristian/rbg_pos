class Order < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:reference_number, :search_term]
  multisearchable against: [:reference_number]
  belongs_to :destination_store_front, class_name: "StoreFront", foreign_key: 'destination_store_front_id', optional: true
  belongs_to :commercial_document, polymorphic: true, optional: true
  belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
  has_one :cash_payment, as: :cash_paymentable, class_name: "StoreFrontModule::CashPayment"
  has_one :entry, as: :commercial_document, class_name: "AccountingModule::Entry", dependent: :destroy
  has_many :line_items, dependent: :destroy

  delegate :full_name, to: :customer, prefix: true, allow_nil: true
  delegate :full_name, to: :technician, prefix: true, allow_nil: true
  delegate :cash_tendered, to: :cash_payment, prefix: true, allow_nil: true
  delegate :full_name, to: :employee, prefix: true, allow_nil: true
  delegate :discount_amount, to: :cash_payment, allow_nil: true
  delegate :name, to: :destination_store_front, prefix: true, allow_nil: true
  before_validation :set_date

  def self.credit
    all.select{|a| a.credit? }
  end

  def self.ordered_on(hash={})
    if hash[:from_date] && hash[:to_date]
      from_date = Chronic.parse(hash[:from_date].to_date)
      to_date = Chronic.parse(hash[:to_date].to_date)
      where('date' => (from_date.beginning_of_day)..(to_date.end_of_day))
    else
      all
    end
  end
  def total_cost
    entry.try(:total) || try(:cash_payment).try(:cash_tendered)
  end
  def total_quantity
    line_items.sum(&:quantity)
  end

  def self.created_between(hash={})
    if hash[:from_date] && hash[:to_date]
      from_date = hash[:from_date].kind_of?(DateTime) ? hash[:from_date] : Chronic.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
      to_date = hash[:to_date].kind_of?(DateTime) ? hash[:to_date] : Chronic.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
      where('date' => (from_date.beginning_of_day)..(to_date.end_of_day))
    else
      all
    end
  end
  def line_items_total_cost
    line_items.sum(:total_cost)
  end


  def line_items_name
    line_items.map{|a| a.product_name }.to_s.gsub("[", "").gsub("]", "").gsub('"', "")
  end

  def line_items_name_and_barcode
    line_items.map{|a| a.stock_name_and_barcode }.to_s.gsub("[", "").gsub("]", "").gsub('"', "")
  end

  def cost_of_goods_sold
    line_items.sum(&:cost_of_goods_sold)
  end

  def income
    total_cost_less_discount - cost_of_goods_sold
  end

  private
  def set_date
  	self.date ||= Time.zone.now
  end
end
