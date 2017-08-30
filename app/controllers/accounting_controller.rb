class AccountingController < ApplicationController
	def index 
		@entries = AccountingModule::Entry.all.order(entry_date: :desc).page(params[:page]).per(35)
    @expenses = AccountingModule::Entry.expense.all.order(entry_date: :desc).page(params[:page]).per(35)
	end 
end 