module Accounting
  module BankAccounts
    class Withdrawal
      include ActiveModel::Model
      attr_accessor :bank_account_id, :employee_id, :destination_account_id, :amount, :date, :reference_number, :description

      validates :amount, :bank_account_id, :destination_account_id, :reference_number, :description, presence: true

      def save!
        ActiveRecord::Base.transaction do
          save_deposit
        end
      end

      private
       def save_deposit
        find_bank_account.entries.create(
          recorder: find_employee,
          entry_date: date,
          reference_number: reference_number,
          description: description,
          debit_amounts_attributes: [amount: amount, account_id: destination_account_id],
          credit_amounts_attributes: [amount: amount, account: find_bank_account.cash_in_bank_account]
          )
      end

      def find_bank_account
        BankAccount.find_by_id(bank_account_id)
      end

      def find_employee
        User.find_by_id(employee_id)
      end
    end
  end
end
