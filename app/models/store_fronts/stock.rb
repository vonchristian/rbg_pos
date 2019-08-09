module StoreFronts
  class Stock < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :text_search, against: [:barcode], associated_against: { product: [:name] }
    belongs_to :store_front
    belongs_to :product
    belongs_to :unit_of_measurement, class_name: 'StoreFrontModule::UnitOfMeasurement'
    has_one    :purchase,            class_name: 'StoreFrontModule::LineItems::PurchaseOrderLineItem'
    has_many   :sales,               class_name: 'StoreFrontModule::LineItems::SalesOrderLineItem'
    has_many   :stock_transfers,     class_name: 'StoreFrontModule::LineItems::StockTransferOrderLineItem'
    has_many   :internal_uses,       class_name: 'StoreFrontModule::LineItems::InternalUseOrderLineItem'
    has_many   :spoilages,           class_name: 'StoreFrontModule::LineItems::SpoilageOrderLineItem'
    has_many   :purchase_returns,    class_name: 'StoreFrontModule::LineItems::PurchaseReturnOrderLineItem'
    has_many   :for_warranties,      class_name: 'StoreFrontModule::LineItems::ForWarrantyOrderLineItem'
    has_many   :sales_returns,       class_name: 'StoreFrontModule::LineItems::SalesReturnOrderLineItem'

    delegate :name,           to: :product
    delegate :unit_code,      to: :unit_of_measurement
    delegate :purchase_order, to: :purchase
    delegate :supplier,       to: :purchase_order
    delegate :name,           to: :supplier,       prefix: true
    delegate :date,           to: :purchase_order, prefix: true, allow_nil: true

    def self.processed
      joins(:purchase).where.not('line_items.order_id' => nil)
    end

    def balance_for_cart(cart)
      balance -
      sales.where(cart: cart).sum(&:quantity)
    end
    def balance_for_cart_on_transfer(cart)
      balance -
      stock_transfers.processed.where(cart: cart).sum(&:quantity)
    end

    def self.available
      where(available: true)
    end

    def purchase_quantity
      purchase.quantity
    end


    def balance
      purchase_quantity      +
      sales_returns.total    -
      purchase_returns.total -
      stock_transfers.total  -
      sales.total            -
      internal_uses.total    -
      spoilages.total        -
      for_warranties.total
    end

    def sold?
      balance.zero? && sales.present?
    end
    def latest_selling_price(store_front)
      unit_of_measurement.selling_prices.where(store_front: store_front).current_price
    end
    def last_purchase_cost
      purchase.unit_cost
    end

    def total_cost
      purchase_quantity * last_purchase_cost
    end

  end
end
