module StoreFrontModule
  module LineItems
    class WorkOrderLineItem < LineItem
      belongs_to :work_order, class_name: "StoreFrontModule::Orders::WorkOrder"
    end
  end
end
