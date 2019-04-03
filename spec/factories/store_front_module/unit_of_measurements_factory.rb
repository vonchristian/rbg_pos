FactoryBot.define do
  factory :unit_of_measurement, class: StoreFrontModule::UnitOfMeasurement do
    association :product
    unit_code { 'pc' }
    quantity  { 1 }
  end
end
