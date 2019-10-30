FactoryBot.define do
  factory :account_category, class: AccountingModule::AccountCategory do
    title { "MyString" }
    account_code { "MyString" }
    type { "" }
    contra { false }
    association :business

    factory :asset_account_category, class: AccountingModule::AccountCategories::Asset do
    end

    factory :revenue_account_category, class: AccountingModule::AccountCategories::Revenue do
    end
  end
end
