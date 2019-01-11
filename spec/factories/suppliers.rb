FactoryBot.define do
  factory :supplier do
    business_name  { Faker::Company.name }
    owner_name "MyString"
    address "MyString"
    contact_number "MyString"
  end
end
