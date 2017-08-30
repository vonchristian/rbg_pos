module AccountingModule 
  class CustomerPaymentForm
    include ActiveModel::Model 
    attr_accessor :entry_date,
                  :reference_number,
                  :description,
                  :customer_id,
                  :user_id,
                  :debit_account_id,
                  :credit_account_id,
                  :amount 
    validates :entry_date, :description,  presence: true
    validates :amount, presence: true, numericality: true
    def save 
      ActiveRecord::Base.transaction do 
        create_entry 
      end 
    end 

    private 
    def create_entry 
      AccountingModule::Entry.customer_credit_payment.create!(user_id: user_id, commercial_document_id: customer_id, commercial_document_type: "Customer", entry_date: entry_date, reference_number: reference_number, description: description,
        credit_amounts_attributes: [amount: amount, account_id: credit_account_id],
        debit_amounts_attributes: [amount: amount, account_id: debit_account_id])
    end 
  end 
end