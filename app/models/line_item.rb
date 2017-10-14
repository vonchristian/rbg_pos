class LineItem < ApplicationRecord
  has_one :sales_return
  belongs_to :cart, optional: true
  belongs_to :stock, optional: true
  belongs_to :order, optional: true
  belongs_to :work_order, optional: true

  
  delegate :barcode, :product_name, :product_unit, to: :stock
  delegate :name_and_barcode, to: :stock, prefix: true
  
  validate :exceeds_available_stock?, on: :create
  after_commit :set_total_cost, on: [:create, :update]
  def search 
  end
  def self.not_stock_transfer
    all.select{|a| !a.stock_transfer? }
  end
  def stock_transfer?
    order.stock_transfer?
  end
  def self.total_cost
    all.sum(&:unit_cost_and_quantity)
  end
  def unit_cost_and_quantity
  	unit_cost * quantity
  end
  def returned?
    sales_return.present?
  end
  def remove_entry
    entry = work_order.entries.work_order_credit.where(user_id: self.user_id).last
    if entry.present?
      entry.destroy
    end
  end
  def remove_order 
    if order.present? && order.line_items.count == 1
      order.destroy
    end
  end
  private 
  def exceeds_available_stock?
    errors[:base] << "Exceeded available stock" if quantity > stock.in_stock
  end
  def set_total_cost 
    self.total_cost = self.quantity * self.unit_cost + markup_amount
  end
end
