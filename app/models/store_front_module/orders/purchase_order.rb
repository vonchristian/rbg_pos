module StoreFrontModule
  module Orders
    class PurchaseOrder < Order
      has_many :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'order_id'
    end
  end
end

