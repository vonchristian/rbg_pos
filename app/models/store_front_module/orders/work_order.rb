module StoreFrontModule
  module Orders
    class WorkOrder
      has_many :work_order_line_items, class_name: "StoreFrontModule::LineItems::WorkOrderLineItem"
    end
  end
end