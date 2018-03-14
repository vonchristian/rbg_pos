module StoreFrontModule
  module LineItems
    class ReferencedSalesOrderLineItem < LineItem
      belongs_to :sales_order_line_item, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'sales_order_line_item_id'
      belongs_to :purchase_order_line_item, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'referenced_purchase_order_line_item_id'
    end
  end
end
