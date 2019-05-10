module AccountingModule
  class Account < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:name, :account_code]



    class_attribute :normal_credit_balance
    belongs_to :business
    has_many :sub_accounts, class_name: "AccountingModule::SubAccount", foreign_key: 'main_account_id'
    has_many :amounts, class_name: "AccountingModule::Amount"
    has_many :credit_amounts, :extend => AmountsExtension, :class_name => 'AccountingModule::CreditAmount'
    has_many :debit_amounts, :extend => AmountsExtension, :class_name => 'AccountingModule::DebitAmount'
    has_many :entries, through: :amounts, source: :entry
    has_many :credit_entries, :through => :credit_amounts, :source => :entry, :class_name => 'AccountingModule::Entry'
    has_many :debit_entries, :through => :debit_amounts, :source => :entry, :class_name => 'AccountingModule::Entry'

    validates :type, presence: true
    validates :name, :account_code, presence: true, uniqueness: true

    scope :assets,     -> { where(type: 'AccountingModule::Asset') }
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
      if self.new.class == AccountingModule::Account
        raise(NoMethodError, "undefined method 'balance'")
      else
        accounts_balance = BigDecimal('0')
        accounts = self.all
        accounts.each do |account|
          if account.contra
            accounts_balance -= account.balance(options)
          else
            accounts_balance += account.balance(options)
          end
        end
        accounts_balance
      end
    end

    def self.debits_balance(options={})

        accounts_balance = BigDecimal('0')
        accounts = self.all
        accounts.each do |account|
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
        accounts = self.all
        accounts.each do |account|
          if account.contra
            accounts_balance -= account.credits_balance(options)
          else
            accounts_balance += account.credits_balance(options)
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
      if self.class == AccountingModule::Account
        raise(NoMethodError, "undefined method 'balance'")
      else
        if self.normal_credit_balance ^ contra
          credits_balance(options) - debits_balance(options)
        else
          debits_balance(options) - credits_balance(options)
        end
      end
    end
    def credits_balance(options={})
      credit_amounts.balance(options)
    end
    def debits_balance(options={})
      debit_amounts.balance(options)
    end
    def deactivate!
      self.active = false
      self.save
    end
  end
end
