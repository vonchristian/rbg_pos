class Payment < ApplicationRecord
	enum mode_of_payment: [:cash, :credit, :stock_transfer]
  belongs_to :order
  before_save :set_total_cost_less_discount
  private
  def set_total_cost_less_discount
  	self.total_cost_less_discount ||= self.total_cost
  end
end
