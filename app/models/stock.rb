class Stock < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:barcode, :name]
  belongs_to :supplier
  belongs_to :product
  has_many :line_items
  validates :quantity, :unit_cost, :retail_price, :wholesale_price, presence: true, numericality: { greater_than: 0.1 }
  
  delegate :name, :unit, :in_stock, to: :product, prefix: true
  delegate :avatar, to: :product
  before_validation :set_date
  
  private 
  def set_date 
  	self.date ||= Time.zone.now 
  end
end
