class StockTransfer < ApplicationRecord
  belongs_to :stock
  belongs_to :destination_branch, class_name: "Branch", foreign_key: 'destination_branch_id'
  belongs_to :origin_branch, class_name: "Branch", foreign_key: 'destination_branch_id'

  validates :quantity, presence: true, numericality: { greater_than: 0.1 }
  validates :date, presence: true
  before_validation :set_default_date
  private 
  def set_default_date 
  	self.date ||= Time.zone.now 
  end 
end
