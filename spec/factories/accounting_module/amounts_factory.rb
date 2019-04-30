FactoryBot.define do
  factory :amount, :class => AccountingModule::Amount do |amount|
    amount.amount { BigDecimal('473') }
    amount.association :entry, :factory => :entry_with_credit_and_debit
    amount.association :account, :factory => :asset
    factory :credit_amount, :class => AccountingModule::CreditAmount do
    end

    factory :debit_amount, :class => AccountingModule::DebitAmount do
    end
  end
end
