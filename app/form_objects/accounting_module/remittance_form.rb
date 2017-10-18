module AccountingModule 
	class RemittanceForm
		include ActiveModel::Model 
		attr_accessor :entry_date,
	                :cashier_id,
		              :reference_number,
		              :description,
		              :debit_account_id,
		              :credit_account_id,
		              :amount,
                  :recorder_id
		validates :entry_date, :description, :cashier_id, presence: true
		validates :amount, presence: true, numericality: true
	  def save 
	  	ActiveRecord::Base.transaction do 
	  		create_entry 
	  	end 
	  end 

	  private 
	  def create_entry 
	  	AccountingModule::Entry.fund_transfer.create!(recorder_id: recorder_id, commercial_document_id: cashier_id, commercial_document_type: "User", entry_date: entry_date, reference_number: reference_number, description: description,
	  		credit_amounts_attributes: [amount: amount, account_id: credit_account_id],
	  		debit_amounts_attributes: [amount: amount, account_id: debit_account_id])
	  end 
	end 
end