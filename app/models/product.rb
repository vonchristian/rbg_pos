class Product < ApplicationRecord
	include PgSearch
  multisearchable against: [:name]
	pg_search_scope :text_search, against: [:name], :associated_against => {:purchases => [:bar_code] }
  pg_search_scope :text_search_with_barcode, against: [:name],
  :associated_against => {
    :purchases => [:bar_code]}

  belongs_to :category, optional: true
	has_many :stocks
	has_many :line_items
	has_many :orders, through: :sold_items
	has_many :sales_returns, through: :sold_items
	has_many :returned_items, through: :sold_items,  source: :sales_return #Sales Return
	has_many :items_under_warranty, through: :sales_returns, source: :warranty #forwarded items to supplier
	has_many :released_warranties, through: :items_under_warranty, source: :warranty_release

  has_many :unit_of_measurements, class_name: "StoreFrontModule::UnitOfMeasurement"

  has_many :purchases, :class_name => 'StoreFrontModule::LineItems::PurchaseOrderLineItem'
  has_many :internal_uses, :class_name => 'StoreFrontModule::LineItems::InternalUseOrderLineItem'
  has_many :sales, :class_name => 'StoreFrontModule::LineItems::SalesOrderLineItem'
  has_many :sales_orders, :through => :sales, :source => :sales_order, :class_name => 'StoreFrontModule::Orders::SalesOrder'
  has_many :purchase_orders, :through => :purchases, :source => :order, :class_name => 'StoreFrontModule::Orders::PurchaseOrder'
  has_many :received_stock_transfer_orders, through: :received_stock_transfers, source: :order, class_name: "StoreFrontModule::Orders::ReceivedStockTransferOrder"
  has_many :sales_returns, class_name: "StoreFrontModule::LineItems::SalesReturnOrderLineItem"
  has_many :purchase_returns, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem"
  has_many :spoilages, class_name: "StoreFrontModule::LineItems::SpoilageOrderLineItem"
  has_many :stock_transfers, class_name: "StoreFrontModule::LineItems::StockTransferOrderLineItem"
  has_many :selling_prices, class_name: "StoreFrontModule::SellingPrice"
  has_many :received_stock_transfers, class_name: "StoreFrontModule::LineItems::ReceivedStockTransferOrderLineItem"
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
  # validates :name, presence: true

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
    all.to_a.sort_by(&:line_items_count).reverse
  end
  def line_items_count
    line_items.total
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
  def last_purchase_cost
    purchases.last.try(:unit_cost)
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



	def in_stock
		balance
	end
	def sold_items_count
		sales_balance
	end
	def delivered_items_count
		purchases_balance
	end
	def transferred_stocks_count
    stock_transfers_balance
	end
	def returned_items_count
		sales_returns_balance
	end


  def update_stocks_name
    stocks.each do |stock|
      stock.name = self.name
      stock.save
    end
  end
  ################################
  def last_purchase_cost
    purchases.order(created_at: :desc).last.try(:unit_cost)
  end
  def available_quantity
    balance
  end
  def balance(options={})
    sales_returns_balance(options) +
    purchases_balance(options) -
    sales_balance(options) -
    stock_transfers_balance(options) -
    spoilages_balance(options) -
    internal_use_orders_balance(options)
  end
  def sales_balance(options={})
    sales.balance(options)
  end
  def sales_returns_balance(options={})
    sales_returns.balance(options)
  end

  def purchases_balance(options={})
    purchases.balance(options) -
    purchase_returns.balance(options)
  end
  def spoilages_balance(options={})
    spoilages.balance(options)
  end
  def stock_transfers_balance(options={})
    stock_transfers.balance(options)
  end
  def internal_use_orders_balance(options={})
    internal_uses.balance(options)
  end
end
