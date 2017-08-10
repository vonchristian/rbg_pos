class Stock < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:barcode, :name]
  belongs_to :supplier
  belongs_to :product
  belongs_to :branch
  has_many :line_items
  has_many :stock_transfers
  validates :quantity, :unit_cost, :retail_price, :wholesale_price, presence: true, numericality: { greater_than: 0.1 }
  
  delegate :name, :unit, :in_stock, to: :product, prefix: true
  delegate :avatar, to: :product
  delegate :business_name, to: :supplier, prefix: true
  before_validation :set_date
  def in_stock
    quantity - stock_transfers.sum(:quantity)
  end
  private 
  def set_date 
  	self.date ||= Time.zone.now 
  end
end
