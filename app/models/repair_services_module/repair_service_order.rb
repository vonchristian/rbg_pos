module RepairServicesModule
  class RepairServiceOrder < Order
    has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'order_id'
    delegate :name, to: :customer, prefix: true
    def customer
      commercial_document
    end
    def total_cost
      sales_order_line_items.sum(&:total_cost)
    end
  end
end
