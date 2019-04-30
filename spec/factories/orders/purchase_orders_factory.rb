FactoryBot.define do
  factory :purchase_order, class: StoreFrontModule::Orders::PurchaseOrder do
    association :store_front
    association :employee, factory: :user
    association :supplier
    account_number { SecureRandom.uuid }
  end
end
