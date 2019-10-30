FactoryBot.define do
  factory :parent_account_category, class: AccountingModule::ParentAccountCategory do
     title       { Faker::Company.bs }
    account_code { SecureRandom.uuid }
    association :business
    contra { false }

    factory :asset_parent_account_category, class: AccountingModule::ParentAccountCategories::Asset do
    end
  end
end
