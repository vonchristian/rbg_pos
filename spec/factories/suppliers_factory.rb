FactoryBot.define do
  factory :supplier do
    business_name { Faker::Company.name }
  end
end
