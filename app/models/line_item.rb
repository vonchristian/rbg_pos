class LineItem < ApplicationRecord
  include PgSearch
  pg_search_scope :text_search, against: [:bar_code]
  multisearchable against: [:bar_code]
  belongs_to :store_front, optional: true
  belongs_to :commercial_document, polymorphic: true, optional: true
  belongs_to :cart, optional: true
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :registry, optional: true
  belongs_to :referenced_line_item, class_name: "StoreFrontModule::LineItem", optional: true
  belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"
  delegate :unit_code, :conversion_multiplier, to: :unit_of_measurement, allow_nil: true
  delegate :name, to: :product
  delegate :name, to: :product, prefix: true


  def self.with_orders
    where.not(order_id: nil)
  end

  def self.processed
    where.not(order_id: nil)
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
  def self.total_converted_quantity
    all.sum(&:converted_quantity)
  end

  def converted_quantity
    quantity * default_conversion_multiplier
  end

  def default_conversion_multiplier
    conversion_multiplier || 1
  end

  def processed?
    order_id.present?
  end

  def self.balance(args={})
    balance_finder.new(args.merge(line_items: self)).compute
  end

  private
  def self.balance_finder(args={})
    if args.present?
      klass = args.select{|key, value| !value.nil?}.keys.sort.map{ |key| key.to_s.titleize }.join.gsub(" ", "")
    else
      klass = "DefaultBalanceFinder"
    end
      ("StoreFrontModule::BalanceFinders::" + klass).constantize
  end

  def exceeds_available_stock?
    errors[:base] << "Exceeded available stock" if quantity > stock.in_stock
  end
end
