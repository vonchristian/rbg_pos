module RepairServicesModule
  class RepairServiceOrderLineItem < LineItem
    belongs_to :cart
    belongs_to :repair_service_order, class_name: "RepairServicesModule::RepairServiceOrder", optional: true
    has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", foreign_key: 'sales_order_line_item_id', dependent: :destroy
  end
end
