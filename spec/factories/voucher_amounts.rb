FactoryBot.define do
  factory :voucher_amount do
    amount "9.99"
    account nil
    voucher nil
    commercial_document nil
    description "MyString"
    amount_type 1
  end
end
