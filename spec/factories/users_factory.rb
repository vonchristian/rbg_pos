FactoryBot.define do
  factory :user, aliases: [:employee] do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.email }
    association :store_front
    association :business
    password   { 'secret_password' }
    password_confirmation { 'secret_password' }

    factory :proprietor, class: User do
      role { 'proprietor' }
    end
    factory :sales_clerk, class: 'User' do
      role { 'sales_clerk' }
    end 
  end
end
