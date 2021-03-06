module RepairServicesModule
  class PaymentProcessing
    include ActiveModel::Model
    attr_accessor :description, :amount, :date, :employee_id, :customer_id, :work_order_id, :expense_amount, :expense_account_id
    validates :description, :amount, :date, :customer_id, presence: true
    validates :amount, numericality: true

    def process!
      ActiveRecord::Base.transaction do
        create_payment
      end
    end

    private
    def create_payment
      accounts_receivable = find_work_order.default_receivable_account
      cash_on_hand_account = find_employee.cash_on_hand_account
      if expense_account_id.blank? && expense_amount.to_i.zero?
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_customer,
          entry_date: date,
          description: description,
          debit_amounts_attributes: [amount: amount,
                                        account: cash_on_hand_account

                                     ],
            credit_amounts_attributes:[ amount: amount,
                                        account: accounts_receivable
                                      ])
      else
      find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_customer,
          entry_date: date,
          description: description,
          debit_amounts_attributes: [{ amount: amount,
                                        account: cash_on_hand_account},
                                      { amount: expense_amount,
                                        account_id: expense_account_id }
                                     ],
            credit_amounts_attributes:[ amount: amount.to_f + expense_amount.to_f,
                                        account: accounts_receivable
                                      ])
    end
    end
    def amount_less_expense
      amount.to_f - expense_amount.to_f
    end
    def find_employee
      User.find_by_id(employee_id)
    end
    def find_customer
      Customer.find_by_id(customer_id)
    end
    def find_work_order
      WorkOrder.find_by_id(work_order_id)
    end
  end
end
