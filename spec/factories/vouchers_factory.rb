FactoryBot.define do
  factory :voucher do
    association :payee, factory: :customer
    association :commercial_document, factory: :purchase_order
    account_number { SecureRandom.uuid }
  end

end
