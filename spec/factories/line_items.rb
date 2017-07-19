FactoryGirl.define do
  factory :line_item do
    cart nil
    stock nil
    unit_cost "9.99"
    total_cost "9.99"
    quantity "9.99"
  end
end
