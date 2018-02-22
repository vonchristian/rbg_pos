module RepairServicesModule
  class RepairServiceOrder < Order
    has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'order_id'
  end
end
