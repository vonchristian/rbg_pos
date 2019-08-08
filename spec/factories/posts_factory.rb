FactoryBot.define do
  factory :post do
    title   { Faker::Name.first_name }
    content { Faker::Company.bs }
    date    { Date.current }
    association :user
    association :updateable, factory: :work_order
  end
end
