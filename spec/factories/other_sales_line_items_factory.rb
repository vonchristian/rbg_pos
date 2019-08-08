FactoryBot.define do
  factory :other_sales_line_item do
    amount { Faker::Number.number(digits: 4) }
  end
end 
