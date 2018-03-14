class LineItem < ApplicationRecord
  extend StoreFrontModule::QuantityBalanceFinder
  include PgSearch
  pg_search_scope :text_search, against: [:bar_code]
  multisearchable against: [:bar_code]
  belongs_to :commercial_document, polymorphic: true, optional: true
  belongs_to :cart, optional: true
  belongs_to :stock, optional: true
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :registry, optional: true
  belongs_to :referenced_line_item, optional: true, class_name: "StoreFrontModule::LineItem", optional: true
  belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"
  delegate :unit_code, :conversion_multiplier, to: :unit_of_measurement, allow_nil: true
  delegate :name, to: :product

  def date
    order.try(:date) || self.created_at
  end


  def product_name
    product.name
  end
  def purchase_cost
    stock.unit_cost
  end

  def self.total_cost
    all.sum(&:unit_cost_and_quantity)
  end

  def unit_cost_and_quantity
  	unit_cost * quantity
  end

  def self.total
    all.sum(&:converted_quantity)
  end
  def converted_quantity
    if conversion_multiplier.present?
      quantity * conversion_multiplier
    else
      quantity
    end
  end

  private
  def exceeds_available_stock?
    errors[:base] << "Exceeded available stock" if quantity > stock.in_stock
  end
  ######################

end
