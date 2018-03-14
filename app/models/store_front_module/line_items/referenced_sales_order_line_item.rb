module StoreFrontModule
  module LineItems
    class ReferencedSalesOrderLineItem < LineItem
      belongs_to :purchase_order_line_item, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'purchase_order_line_item_id'
    end
  end
end
