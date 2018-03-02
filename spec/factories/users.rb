FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password 'secret_password'
    password_confirmation 'secret_password'
  end
end
