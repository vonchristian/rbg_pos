FactoryBot.define do
  factory :account_category do
    title { "MyString" }
    account_code { "MyString" }
    type { "" }
    contra { false }
    business { nil }
  end
end
