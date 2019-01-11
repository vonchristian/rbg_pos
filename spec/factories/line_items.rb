FactoryBot.define do
  factory :line_item do
    cart nil
    association :unit_of_measurement
    unit_cost  { 100 }
    total_cost { 100 }
    quantity   { 1 }

    factory :sales_order_line_item, class: StoreFrontModule::LineItems::SalesOrderLineItem do
    end

    factory :sales_return_order_line_item, class: StoreFrontModule::LineItems::SalesReturnOrderLineItem do
    end
    factory :purchase_order_line_item, class: StoreFrontModule::LineItems::PurchaseOrderLineItem do
    end
    factory :purchase_return_order_line_item, class: StoreFrontModule::LineItems::PurchaseReturnOrderLineItem do
    end
    factory :internal_use_order_line_item, class: StoreFrontModule::LineItems::InternalUseOrderLineItem do
    end
    factory :spoilage_order_line_item, class: StoreFrontModule::LineItems::SpoilageOrderLineItem do
    end
  end
end
