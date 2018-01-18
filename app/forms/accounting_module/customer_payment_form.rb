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
                  :amount,
                  :discount_amount
    validates :entry_date, :description,  presence: true
    validates :amount, presence: true, numericality: true
    def save 
      ActiveRecord::Base.transaction do 
        create_entry 
        create_order
      end 
    end 

    private 
    def create_entry 
      AccountingModule::Entry.customer_credit_payment.create!(recorder_id: user_id, commercial_document_id: customer_id, commercial_document_type: "Customer", entry_date: entry_date, reference_number: reference_number, description: description,
        credit_amounts_attributes: [amount: amount, account_id: credit_account_id],
        debit_amounts_attributes: [amount: amount, account_id: User.find_by(id: user_id).cash_on_hand_account.id])
    end 
    def create_order
      order = Order.create!(description: description, customer_id: customer_id, date: entry_date, employee_id: user_id)
      Payment.create(mode_of_payment: 'cash', order: order, discount_amount: discount_amount, total_cost: amount)
    end
  end 
end