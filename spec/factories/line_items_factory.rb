FactoryBot.define do
  factory :line_item do
    association :unit_of_measurement
    factory :sales_order_line_item, class: 'StoreFrontModule::LineItems::SalesOrderLineItem' do
    end
  end
end
