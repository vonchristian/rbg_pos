FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    association :business
  end
end
