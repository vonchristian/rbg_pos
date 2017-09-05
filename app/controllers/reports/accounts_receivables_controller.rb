module Reports
  class AccountsReceivablesController < ApplicationController 
    def index 
      @customers = Customer.with_credits.sort
      respond_to do |format|
        format.pdf do 
          pdf = Reports::AccountsReceivablesPdf.new(@customers, view_context)
          send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'AR Report.pdf'
        end
      end
    end 
  end 
end