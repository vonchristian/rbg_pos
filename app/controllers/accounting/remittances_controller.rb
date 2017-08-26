module Accounting 
	class RemittancesController < ApplicationController
		def new 
			@entry = AccountingModule::RemittanceForm.new 
		end 
		def create 
			@entry = AccountingModule::RemittanceForm.new(entry_params)
			if @entry.valid?
				@entry.save 
				redirect_to accounting_index_url, notice: "Collection remittance saved successfully."
			else 
				render :new 
			end 
		end 

		private 
		def entry_params
			params.require(:accounting_module_remittance_form).permit(:cashier_id, :entry_date, :reference_number, :description, :debit_account_id, :credit_account_id, :amount)
		end
	end
end