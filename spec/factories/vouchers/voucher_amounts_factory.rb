FactoryBot.define do
  factory :voucher_amount, class: Vouchers::VoucherAmount do
    amount_type 'debit'
    amount { Faker::Number.number(5) }
    association :account, factory: :asset
    association :commercial_document, factory: :user
    association :recorder, factory: :user

  end
end
