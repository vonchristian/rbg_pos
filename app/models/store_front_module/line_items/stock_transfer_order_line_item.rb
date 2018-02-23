module StoreFrontModule
  module LineItems
    class StockTransferOrderLineItem < LineItem
      belongs_to :stock_transfer_order, class_name: "StoreFrontModule::Orders::StockTransferOrder", foreign_key: 'order_id', optional: true

    end
  end
end
