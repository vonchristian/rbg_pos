module AccountingModule
  class Account < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :text_search, :against => [:name, :account_code]
    class_attribute :normal_credit_balance
    belongs_to :business

    has_many :amounts,        class_name: 'AccountingModule::Amount'
    has_many :credit_amounts, class_name: 'AccountingModule::CreditAmount'
    has_many :debit_amounts,  class_name: 'AccountingModule::DebitAmount'
    has_many :entries,        through: :amounts, class_name: 'AccountingModule::Entry'
    has_many :credit_entries, through: :credit_amounts, source: :entry, class_name: 'AccountingModule::Entry'
    has_many :debit_entries,  through: :debit_amounts, source: :entry, class_name: 'AccountingModule::Entry'

    validates :type, presence: true
    validates :name, :account_code, presence: true, uniqueness: { scope: :business_id }

    scope :assets,      -> { where(type: 'AccountingModule::Asset') }
    scope :liabilities, -> { where(type: 'AccountingModule::Liability') }
    scope :equities,    -> { where(type: 'AccountingModule::Equity') }
    scope :revenues,    -> { where(type: 'AccountingModule::Revenue') }
    scope :expenses,    -> { where(type: 'AccountingModule::Expense') }

    def self.cash_on_hand_accounts
      accounts = User.pluck(:cash_on_hand_account_id)
     where(id: accounts)
    end
    def self.debit_entries
      ids = AccountingModule::DebitAmount.for_account(account_id: self.pluck(:id)).pluck(:entry_id)
      AccountingModule::Entry.where(id: ids)
    end

    def self.credit_entries
      ids = AccountingModule::CreditAmount.for_account(account_id: self.pluck(:id)).pluck(:entry_id)
      AccountingModule::Entry.where(id: ids)
    end

    def self.active
      where(active: true)
    end
    def self.types
      ["AccountingModule::Asset",
       "AccountingModule::Equity",
       "AccountingModule::Liability",
       "AccountingModule::Expense",
       "AccountingModule::Revenue"]
     end

     def self.balance(options={})
       accounts_balance ||= BigDecimal('0')
       self.all.each do |account|
         if account.contra?
           accounts_balance -= account.balance(options)
         else
           accounts_balance += account.balance(options)
         end
       end
       accounts_balance
     end

     def self.debits_balance(options={})
       accounts_balance = BigDecimal('0')
       self.all.each do |account|
         if account.contra
           accounts_balance -= account.debits_balance(options)
         else
           accounts_balance += account.debits_balance(options)
         end
       end
       accounts_balance
     end

     def self.credits_balance(options={})
       accounts_balance = BigDecimal('0')
       self.all.each do |account|
         if account.contra
           accounts_balance -= account.credits_balance(options)
         else
           accounts_balance += account.credits_balance(options)
         end
       end
       accounts_balance
     end

    def self.trial_balance
     return raise(NoMethodError, "undefined method 'trial_balance'") unless self.new.class == AccountingModule::Account
     assets.balance - (liabilities.balance + equities.balance + revenues.balance - expenses.balance)
    end

    def balance(options={})
      return raise(NoMethodError, "undefined method 'balance'") if self.class == AccountingModule::Account
      if self.normal_credit_balance ^ contra
        credits_balance(options) - debits_balance(options)
      else
        debits_balance(options) - credits_balance(options)
      end
    end

    def credits_balance(options={})
      credit_amounts.balance(options)
    end

    def debits_balance(options={})
      debit_amounts.balance(options)
    end
  end
end
