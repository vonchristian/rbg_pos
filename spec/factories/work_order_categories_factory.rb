FactoryBot.define do
  factory :work_order_category do
    title { Faker::Company.name }
  end
end
