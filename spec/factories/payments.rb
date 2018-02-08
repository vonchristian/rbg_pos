FactoryBot.define do
  factory :payment do
    order nil
    mode_of_payment 1
    cash_tendered "9.99"
    change "9.99"
  end
end
