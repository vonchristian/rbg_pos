FactoryBot.define do
  factory :unit_of_measurement, class: "StoreFrontModule::UnitOfMeasurement" do
    association :product
    unit_code "MyString"
    description "MyString"
    quantity "9.99"
    conversion_quantity "9.99"
    base_measurement false
  end
end
