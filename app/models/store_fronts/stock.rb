module StoreFronts
  class Stock < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :text_search, against: [:barcode]
    belongs_to :store_front
    belongs_to :product
    belongs_to :unit_of_measurement, class_name: 'StoreFrontModule::UnitOfMeasurement'
    has_many   :purchases,        class_name: 'StoreFrontModule::LineItems::PurchaseOrderLineItem'
    has_many   :sales,            class_name: 'StoreFrontModule::LineItems::SalesOrderLineItem'
    has_many   :stock_transfers,  class_name: 'StoreFrontModule::LineItems::StockTransferOrderLineItem'
    has_many   :internal_uses,    class_name: 'StoreFrontModule::LineItems::InternalUseOrderLineItem'
    has_many   :spoilages,        class_name: 'StoreFrontModule::LineItems::SpoilageOrderLineItem'
    has_many   :purchase_returns, class_name: 'StoreFrontModule::LineItems::PurchaseReturnOrderLineItem'
    has_many   :for_warranties,   class_name: 'StoreFrontModule::LineItems::ForWarrantyOrderLineItem'
    has_many   :sales_returns,    class_name: 'StoreFrontModule::LineItems::SalesReturnOrderLineItem'

    delegate :name, to: :product
    def purchase_quantity
      purchases.total
    end 
    def balance
      purchases.total        +
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
  end
end
