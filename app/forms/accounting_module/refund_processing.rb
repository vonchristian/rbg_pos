module AccountingModule
  class RefundProcessing
    include ActiveModel::Model

    attr_accessor :amount, :employee_id, :date, :description, :work_order_id
    validates :amount, :employee_id, :date, :description, :work_order_id, presence: true
    validates :amount, numericality: true

    def process!
      ActiveRecord::Base.transaction do
        save_refund
      end
    end

    private
    def save_refund
      cash_on_hand_account = find_employee.cash_on_hand_account
      accounts_receivable = StoreFrontModule::StoreFrontConfig.default_accounts_receivable_account

      AccountingModule::Entry.create(
        recorder: find_employee,
        entry_date: date,
        description: description,
        debit_amounts_attributes: [
          amount: amount,
          account: accounts_receivable,
          commercial_document: find_work_order
        ],
        credit_amounts_attributes: [
          amount: amount,
          account: cash_on_hand_account,
          commercial_document: find_work_order
        ]
      )
    end
    def find_employee
      User.find_by_id(employee_id)
    end
    def find_work_order
      WorkOrder.find_by_id(work_order_id)
    end
  end
end
