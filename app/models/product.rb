class Product < ApplicationRecord
	include PgSearch
  multisearchable against: [:name]
	pg_search_scope :text_search, against: [:name]
  belongs_to :category, optional: true
	has_many :stocks
	has_many :sold_items, through: :stocks, class_name: 'LineItem', source: :line_items
	has_many :orders, through: :sold_items
	has_many :sales_returns, through: :sold_items
	has_many :returned_items, through: :sold_items,  source: :sales_return #Sales Return
	has_many :items_under_warranty, through: :sales_returns, source: :warranty #forwarded items to supplier
	has_many :released_warranties, through: :items_under_warranty, source: :warranty_release

  has_many :unit_of_measurements, class_name: "StoreFrontModule::UnitOfMeasurement"

  has_many :purchases, :class_name => 'StoreFrontModule::LineItems::PurchaseOrderLineItem'
    has_many :sales, :class_name => 'StoreFrontModule::LineItems::SalesOrderLineItem'
    has_many :sales_orders, :through => :sales, :source => :order, :class_name => 'StoreFrontModule::Orders::SalesOrder'
    has_many :purchase_orders, :through => :purchases, :source => :order, :class_name => 'StoreFrontModule::Orders::PurchaseOrder'
    has_many :sales_returns, class_name: "StoreFrontModule::LineItems::SalesReturnOrderLineItem"
    has_many :purchase_returns, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem"
    has_many :spoilages, class_name: "StoreFrontModule::LineItems::SpoilageOrderLineItem"
    has_many :stock_transfers, class_name: "StoreFrontModule::LineItems::StockTransferOrderLineItem"
	has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/default_product_logo.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates :name, presence: true

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :unit_code, to: :base_measurement, prefix: true, allow_nil: true
  def base_measurement
    unit_of_measurements.base_measurement
  end

  def self.low_on_stock
    all.select{ |a| a.low_on_stock? }
  end
  def self.out_of_stock
    all.select{ |a| a.out_of_stock? }
  end
  def self.most_bought
    all.to_a.sort_by(&:number_of_sold_items).reverse
  end
  def number_of_sold_items
    sold_items.count
  end
  def low_on_stock?
    !out_of_stock? && low_stock_count > in_stock
  end
  def out_of_stock?
    in_stock <= 0
  end
  def badge_color
    if out_of_stock?
      "danger"
    elsif low_on_stock?
      "warning"
    else
      "success"
    end
  end


  def self.import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      prod = find_by(id: row["id"]) || new
      member.attributes = row.to_hash
      member.save!
    end
  end

  def transferred_stocks
    orders.stock_transfers
  end

	def in_stock
		((delivered_items_count + returned_items_count) - (sold_items_count))
	end
	def sold_items_count
		sold_items.sum(:quantity)
	end
	def delivered_items_count
		stocks.sum(:quantity)
	end
	def transferred_stocks_count
    if transferred_stocks.any?
		  transferred_stocks.sum(&:total_quantity)
    else
      0
    end
	end
	def returned_items_count
		returned_items.sum(:quantity)
	end


  def update_stocks_name
    stocks.each do |stock|
      stock.name = self.name
      stock.save
    end
  end
  ################################
  def available_quantity
    balance
  end
  def balance(options={})
    purchases_balance(options) -
    sales_balance(options) -
    stock_transfers_balance(options) -
    spoilages_balance(options)
  end
  def sales_balance(options={})
    sales.balance(product_id: self.id) -
    sales_returns.balance(product_id: self.id)
  end

  def purchases_balance(options={})
    purchases.balance(product_id: self.id) -
    purchase_returns.balance(product_id: self.id)
  end
  def spoilages_balance(options={})
    spoilages.balance(product_id: self.id)
  end
  def stock_transfers_balance(options={})
    stock_transfers.balance(product_id: self.id)
  end

end
