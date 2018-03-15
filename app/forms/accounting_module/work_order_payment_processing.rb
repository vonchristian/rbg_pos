module AccountingModule
  class WorkOrderPaymentProcessing
    include ActiveModel::Model
    attr_accessor :entry_date,
                  :reference_number,
                  :description,
                  :work_order_id,
                  :user_id,
                  :amount,
                  :expense_amount,
                  :expense_account_id
    validates :entry_date, :description,  presence: true
    validates :amount, :expense_amount, presence: true, numericality: true
    def save
      ActiveRecord::Base.transaction do
        create_entry
      end
    end

    private
    def create_entry
        if expense_amount.to_f > 0 && expense_account_id.present?
          AccountingModule::Entry.create!(
            recorder_id: user_id,
            commercial_document: find_work_order,
            entry_date: entry_date,
            reference_number: reference_number,
            description: description,
            credit_amounts_attributes:  [
              {
              amount: amount.to_f + expense_amount.to_f,
              account: accounts_receivable_account,
              commercial_document: find_work_order},

              { amount: expense_amount,
                account_id: expense_account_id,
                commercial_document: find_work_order}
              ],
            debit_amounts_attributes: [
              {amount: amount,
               account: cash_on_hand_account,
               commercial_document: find_work_order }
             ])
        else
          AccountingModule::Entry.create!(
            recorder_id: user_id,
            commercial_document: find_work_order,
            entry_date: entry_date,
            reference_number: reference_number,
            description: description,
            credit_amounts_attributes:  [{
              amount: amount,
              account: accounts_receivable_account,
              commercial_document: find_work_order}],
            debit_amounts_attributes: [
              amount: amount,
              account: cash_on_hand_account,
             ])
        end
    end
    def accounts_receivable_account
     AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
    end
    def cash_on_hand_account
      find_employee.default_cash_on_hand_account
    end
    def find_work_order
      WorkOrder.find_by_id(work_order_id)
    end

    def find_employee
      User.find_by_id(user_id)
    end
  end
end
