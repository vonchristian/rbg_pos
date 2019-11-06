FactoryBot.define do
  factory :service_charge do
    description { Faker::ChuckNorris.fact }
    amount       { 100 }
  end
end 
