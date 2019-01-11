FactoryBot.define do
  factory :business do
    name { "#{Faker::Company.name} #{SecureRandom.uuid} #{Faker::Name.name}" }
    owner "MyString"
    address "MyString"
    email "MyString"
    contact_number "MyString"
  end
end
