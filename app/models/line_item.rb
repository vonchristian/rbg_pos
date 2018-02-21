class LineItem < ApplicationRecord
  extend StoreFrontModule::QuantityBalanceFinder
  include PgSearch
  pg_search_scope :text_search, against: [:bar_code]
  has_one :sales_return
  belongs_to :cart, optional: true
  belongs_to :stock, optional: true
  belongs_to :order, optional: true
  belongs_to :work_order, optional: true
  belongs_to :stock_transfer, optional: true
  belongs_to :product, optional: true
  belongs_to :referenced_line_item, optional: true, class_name: "StoreFrontModule::LineItem"
  belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"
  # delegate   :product_unit, :supplier_business_name, :category_name, :stock_type, :retail_price, to: :stock
  delegate :name_and_barcode, to: :stock, prefix: true
  delegate :unit_code, :conversion_multiplier, to: :unit_of_measurement
  delegate :name, to: :product
  # validate :exceeds_available_stock?, on: :create
  # after_commit :set_total_cost, on: [:create, :update]
  def search
  end
  def product_name
    product.name
  end
  def purchase_cost
    stock.unit_cost
  end

  def self.not_stock_transfer
    all.select{|a| !a.stock_transfer? }
  end
  def stock_transfer?
    order.stock_transfer?
  end
  def cost_of_goods_sold
    stock.unit_cost * quantity
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
  def self.total
    all.sum(&:converted_quantity)
  end
  def converted_quantity
    quantity * conversion_multiplier
  end
  private
  def exceeds_available_stock?
    errors[:base] << "Exceeded available stock" if quantity > stock.in_stock
  end
  def set_total_cost
    self.total_cost = self.quantity * self.unit_cost + markup_amount
  end
  ######################

end
