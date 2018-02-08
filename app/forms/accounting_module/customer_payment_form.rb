module AccountingModule
  class CustomerPaymentForm
    include ActiveModel::Model
    attr_accessor :entry_date,
                  :reference_number,
                  :description,
                  :customer_id,
                  :user_id,
                  :credit_account_id,
                  :amount,
                  :expense_amount,
                  :expense_account_id
    validates :entry_date, :description,  presence: true
    validates :amount, presence: true, numericality: true
    validates :amount, :expense_amount, numericality: true
    def save
      ActiveRecord::Base.transaction do
        create_entry
      end
    end

    private
    def create_entry
      AccountingModule::Entry.customer_credit_payment.create!(recorder: find_employee, commercial_document_id: customer_id, commercial_document_type: "Customer", entry_date: entry_date, reference_number: reference_number, description: description,
        credit_amounts_attributes: [ amount: amount, account: credit_account ],
        debit_amounts_attributes: [ {amount: final_amount, account: debit_account },{amount: expense_amount, account_id: expense_account_id}])
    end
    def credit_account
      AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current")
    end
    def debit_account
      find_employee.default_cash_on_hand_account
    end

    def find_employee
      User.find_by_id(user_id)
    end
    def final_amount
      amount.to_f - expense_amount.to_s.to_f
    end
  end
end
