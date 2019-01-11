FactoryBot.define do
  factory :store_front do
    business
    association :merchandise_inventory_account, factory: :asset
    association :sales_account, factory: :revenue
    association :sales_discount_account, factory: :contra_revenue
    association :sales_return_account, factory: :contra_revenue
    association :receivable_account, factory: :asset
    association :internal_use_account, factory: :expense
    association :purchase_return_account, factory: :expense
    association :spoilage_account, factory: :expense
    association :cost_of_goods_sold_account, factory: :asset



    name { "#{Faker::Company.name} #{SecureRandom.uuid} #{Faker::Name.name}" }

  end
end
