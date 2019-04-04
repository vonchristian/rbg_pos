FactoryBot.define do
  factory :purchase_price, class: "StoreFrontModule::PurchasePrice" do
    association :product
    association :unit_of_measurement
    association :store_front
    price       { "9.99" }
    date        { "2019-04-04 08:30:18" }
  end
end
