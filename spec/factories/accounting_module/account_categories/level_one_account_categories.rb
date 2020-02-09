FactoryBot.define do
  factory :level_one_account_category, class: AccountingModule::AccountCategories::LevelOneAccountCategory do
    title { Faker::Company.bs }
    code { SecureRandom.uuid }
    type { "" }
    association :store_front
    contra { false }

    factory :asset_level_one_account_category, class: AccountingModule::AccountCategories::LevelOneAccountCategories::Asset do 
      type { 'AccountingModule::AccountCategories::LevelOneAccountCategories::Asset' }
    end 
  end
end
