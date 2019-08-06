FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    contact_number { Faker::Number.number(digits: 11) }
    association :business
    association :receivable_account, factory: :asset
    association :sales_revenue_account, factory: :asset
    association :sales_discount_account, factory: :asset
    association :service_revenue_account, factory: :asset
  end
end
