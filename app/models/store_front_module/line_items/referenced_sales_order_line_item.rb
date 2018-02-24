module StoreFrontModule
  module LineItems
    class ReferencedSalesOrderLineItem < LineItem
      belongs_to :sales_order_line_item, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'sales_order_line_item_id'
      belongs_to :referencer, polymorphic: true
      belongs_to :purchase_order_line_item, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'purchase_order_line_item_id', optional: true
    end
  end
end
