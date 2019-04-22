FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.email }
    association :store_front
    association :business
    password   { 'secret_password' }
    password_confirmation { 'secret_password' }
  end
end
