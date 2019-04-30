FactoryBot.define do
  factory :sub_account do
    association :main_account, factory: :asset
    association :sub_account,  factory: :asset
  end
end
