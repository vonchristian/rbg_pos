FactoryBot.define do
  factory :parent_account_category do
    title { "MyString" }
    account_code { "MyString" }
    type { "" }
    business { nil }
    contra { false }
  end
end
