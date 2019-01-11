FactoryBot.define do
  factory :account, class: AccountingModule::Account do
    name { "#{Faker::Company.name} #{SecureRandom.uuid} #{Faker::Name.name}" }

    account_code { Faker::Number.number(12) }
    contra false

    factory :asset, class: AccountingModule::Asset do
    end

    factory :revenue, class: AccountingModule::Revenue do
    end

    factory :expense, class: AccountingModule::Expense do
    end

    factory :contra_revenue, class: AccountingModule::Revenue do
      contra true
    end
  end
end
