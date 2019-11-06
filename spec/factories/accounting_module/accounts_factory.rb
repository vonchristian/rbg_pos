FactoryBot.define do
  factory :account, class: AccountingModule::Account do
    association :business
    sequence(:name) { |n| "#{n}" }
    account_code { Faker::Number.number(digits: 12) }

    factory :asset, class: AccountingModule::Asset do

    end

    factory :liability, class: AccountingModule::Liability do

    end

    factory :equity, class: AccountingModule::Equity do

    end

    factory :revenue, class: AccountingModule::Revenue do

    end

    factory :expense, class: AccountingModule::Expense do

    end
  end
end
