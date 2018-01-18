module AccountingModule 
  class ExpenseForm
    include ActiveModel::Model 
    attr_accessor :entry_date,
                  :user_id,
                  :reference_number,
                  :description,
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
      AccountingModule::Entry.create!(entry_type: 'expense', user_id: user_id, entry_date: entry_date, reference_number: reference_number, description: description,
        credit_amounts_attributes: [amount: amount, account_id: credit_account_id],
        debit_amounts_attributes: [amount: amount, account_id: debit_account_id])
    end 
  end 
end