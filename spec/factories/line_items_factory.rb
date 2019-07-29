FactoryBot.define do
  factory :line_item do
    association :unit_of_measurement
    association :product

    factory :purchase_order_line_item, class: 'StoreFrontModule::LineItems::PurchaseOrderLineItem' do
    end

    factory :sales_order_line_item, class: 'StoreFrontModule::LineItems::SalesOrderLineItem' do
    end

    factory :stock_transfer_order_line_item, class: 'StoreFrontModule::LineItems::StockTransferOrderLineItem' do
    end

    factory :internal_use_order_line_item, class: 'StoreFrontModule::LineItems::InternalUseOrderLineItem' do
    end

    factory :spoilage_order_line_item, class: 'StoreFrontModule::LineItems::SpoilageOrderLineItem' do
    end

    factory :purchase_return_order_line_item, class: 'StoreFrontModule::LineItems::PurchaseReturnOrderLineItem' do
    end

    factory :sales_return_order_line_item, class: 'StoreFrontModule::LineItems::SalesReturnOrderLineItem' do
    end

    factory :for_warranty_order_line_item, class: 'StoreFrontModule::LineItems::ForWarrantyOrderLineItem' do
    end
  end
end
