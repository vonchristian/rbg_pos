class OtherSalesLineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :cart, optional: true
  def self.total_cost
    sum(&:amount)
  end
end
