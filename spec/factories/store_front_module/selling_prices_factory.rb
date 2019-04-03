FactoryBot.define do
  factory :selling_price, class: StoreFrontModule::SellingPrice do
    price { 100 }
    association :unit_of_measurement
  end
end
