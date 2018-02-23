module StoreFrontModule
  module LineItems
    class SpoilageOrderLineItem < LineItem
      has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", as: :referencer, dependent: :destroy
    end
  end
end
