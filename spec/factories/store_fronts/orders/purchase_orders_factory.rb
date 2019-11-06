FactoryBot.define do
  factory :purchase_order, class: StoreFrontModule::Orders::PurchaseOrder do
    association :store_front
    association :voucher
    association :employee, factory: :user
    association :supplier, factory: :supplier
    association :payable_account, factory: :liability
    date { Date.current }
    account_number { SecureRandom.uuid }
  end
end
