module AccountingModule
  module AccountCategories
    class LevelOneAccountCategory < ApplicationRecord
      belongs_to :store_front
      has_many :accounts, class_name: 'AccountingModule::Account'
      has_many :credit_amounts, through: :accounts, class_name: 'AccountingModule::CreditAmount'
      has_many :debit_amounts, through: :accounts, class_name: 'AccountingModule::DebitAmount'
      has_many :entries, through: :accounts, class_name: 'AccountingModule::Entry'
      has_many :debit_entries, through: :accounts, class_name: 'AccountingModule::Entry'
      has_many :credit_entries, through: :accounts, class_name: 'AccountingModule::Entry'

      validates :title, :code, :type, presence: true
      validates :title, uniqueness: { scope: :store_front_id }
      def self.types
        [ "AccountingModule::AccountCategories::LevelOneAccountCategories::Asset",
          "AccountingModule::AccountCategories::LevelOneAccountCategories::Equity",
          "AccountingModule::AccountCategories::LevelOneAccountCategories::Liability",
          "AccountingModule::AccountCategories::LevelOneAccountCategories::Expense",
          "AccountingModule::AccountCategories::LevelOneAccountCategories::Revenue"]
      end
    end
  end 
end 
