FactoryBot.define do
  factory :stock, class: StoreFronts::Stock do
    association :product
    association :store_front
    association :unit_of_measurement

  end
end
