FactoryBot.define do
  factory :voucher do
    date "2018-02-21 08:42:37"

    description "MyString"
    payable_amount "9.99"
    type ""

    account_number { SecureRandom.uuid }
    association :preparer, factory: :user
    association :payee, factory: :user

  end
end
