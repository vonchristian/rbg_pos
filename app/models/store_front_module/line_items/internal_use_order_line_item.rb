module StoreFrontModule
  module LineItems
    class InternalUseOrderLineItem < LineItem
      has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", as: :referencer, dependent: :destroy
      belongs_to :internal_use_order, class_name: "StoreFrontModule::Orders::InternalUseOrder", foreign_key: 'order_id', optional: true
    end
  end
end
