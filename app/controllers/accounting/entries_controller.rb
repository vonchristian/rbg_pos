module Accounting 
	class EntriesController < ApplicationController
		def show 
			@entry = AccountingModule::Entry.find(params[:id])
		end 
	end 
end 