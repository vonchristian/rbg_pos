FactoryBot.define do
  factory :store_front do
    sequence(:name) { |n| "#{n}" }
    association :business
    association :merchandise_inventory_account, factory: :asset
    association :sales_account, factory: :revenue
    association :sales_return_account, factory: :revenue
    association :sales_discount_account, factory: :revenue

    association :cost_of_goods_sold_account, factory: :expense
    association :receivable_account, factory: :asset
    association :internal_use_account, factory: :expense
    association :purchase_return_account, factory: :expense
    association :spoilage_account, factory: :expense
    association :service_revenue_account, factory: :revenue
  end
end
