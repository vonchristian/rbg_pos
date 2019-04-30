FactoryBot.define do
  factory :sales_order, class: StoreFrontModule::Orders::SalesOrder do
    association :store_front
    association :employee, factory: :user
    association :commercial_document, factory: :customer
    account_number { SecureRandom.uuid }
  end
end
