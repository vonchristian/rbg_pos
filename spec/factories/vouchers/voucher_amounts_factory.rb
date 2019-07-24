FactoryBot.define do
  factory :voucher_amount, class: Vouchers::VoucherAmount do
    association :account, factory: :asset
    association :commercial_document, factory: :customer
  end
end
