FactoryBot.define do
  factory :entry_with_credit_and_debit, :class => AccountingModule::Entry do |entry_cd|
    description { 'entry description' }
    entry_cd.after(:build) do |t|
      t.credit_amounts << FactoryBot.build(:credit_amount, :entry => t)
      t.debit_amounts << FactoryBot.build(:debit_amount, :entry => t)
    end
  end
end
