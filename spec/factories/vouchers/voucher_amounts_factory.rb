FactoryBot.define do
  factory :voucher_amount, class: Vouchers::VoucherAmount do
    association :account
    association :commercial_document, factory: :customer 
  end
end
