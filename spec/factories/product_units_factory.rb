FactoryBot.define do
  factory :product_unit do
    association :customer
    description { "Description" }
  end
end
