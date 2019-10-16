module AccountingModule
  class ParentAccountCategory < ApplicationRecord
    class_attribute :normal_credit_balance

    belongs_to :business
    has_many :account_categories, class_name: 'AccountingModule::AccountCategory'
    has_many :accounts,       class_name: "AccountingModule::Account", through: :account_categories
    has_many :amounts,        through: :accounts
    has_many :credit_amounts, through: :accounts
    has_many :debit_amounts,  through: :accounts
    has_many :entries,        through: :accounts

    def self.balance(options={})
      accounts_balance ||= BigDecimal('0')
      account_categories = self.all
      account_categories.each do |account_category|
        account_category.accounts.each do |account|
          if account.contra?
            accounts_balance -= account.balance(options)
          else
            accounts_balance += account.balance(options)
          end
        end
      end
      accounts_balance
    end

    def self.debits_balance(options={})
      accounts_balance = BigDecimal('0')
      account_categories = self.all
      account_categories.each do |account_category|
        account_category.accounts.each do |account|
          if account.contra
            accounts_balance -= account.debits_balance(options)
          else
            accounts_balance += account.debits_balance(options)
          end
        end
      end
      accounts_balance
    end

    def self.credits_balance(options={})
      accounts_balance = BigDecimal('0')
      self.all.each do |account_category|
        account_category.each do |account|
          if account.contra
            accounts_balance -= account.credits_balance(options)
          else
            accounts_balance += account.credits_balance(options)
          end
        end
      end
      accounts_balance
    end

   def self.trial_balance
     if self.new.class == AccountingModule::Account
       AccountingModule::Asset.balance - (AccountingModule::Liability.balance + AccountingModule::Equity.balance + AccountingModule::Revenue.balance - AccountingModule::Expense.balance)
     else
       raise(NoMethodError, "undefined method 'trial_balance'")
     end
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
