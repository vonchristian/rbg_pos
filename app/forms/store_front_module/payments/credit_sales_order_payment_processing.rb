module StoreFrontModule
  module Payments
    class CreditSalesOrderPaymentProcessing
      include ActiveModel::Model
      attr_accessor :employee_id, :order_id, :amount, :expense_amount, :expense_account_id, :date, :description, :reference_number, :cash_on_hand_account_id
      validates :date, :order_id, :amount, :reference_number, presence: true
      validates :amount, numericality: true
      def process!
        ActiveRecord::Base.transaction do
          save_payment
        end
      end
      private
      def save_payment
        store_front = find_employee.store_front
        accounts_receivable = find_order.default_receivable_account
        cash_on_hand_account = find_employee.cash_on_hand_account
        if expense_amount.to_f > 0 && expense_account_id.present?
          AccountingModule::Entry.create!(
            recorder: find_employee,
            entry_date: date,
            commercial_document: find_order.customer,
            reference_number: reference_number,
            description: description,
            debit_amounts_attributes:
            [
             {amount: amount,
              account: cash_on_hand_account},
              { amount: expense_amount,
                account_id: expense_account_id
              }
            ],
            credit_amounts_attributes:
            [
              amount: amount.to_f + expense_amount.to_f,
              account: accounts_receivable

            ]
          )
        else
          AccountingModule::Entry.create!(
            recorder: find_employee,
            entry_date: date,
            commercial_document: find_order.customer,
            reference_number: reference_number,
            description: reference_number,

            debit_amounts_attributes:
            [
              amount: amount,
              account: cash_on_hand_account
            ],
            credit_amounts_attributes:
            [
              amount: amount,
              account: accounts_receivable
            ]
          )
        end
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      def find_order
        StoreFrontModule::Orders::SalesOrder.find(order_id)
      end
    end
  end
end
