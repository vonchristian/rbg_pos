module Customers 
  class PaymentsController < ApplicationController
    def new 
      @customer = Customer.find(params[:customer_id])
      @entry = AccountingModule::CustomerPaymentForm.new 
    end 
    def create 
      @customer = Customer.find(params[:customer_id])
      @entry = AccountingModule::CustomerPaymentForm.new(entry_params)
      if @entry.valid?
        @entry.save 
        redirect_to @customer, notice: "Payment saved successfully."
      else 
        render :new 
      end 
    end 

    private 
    def entry_params
      params.require(:accounting_module_customer_payment_form).permit(:user_id, :customer_id, :entry_date, :reference_number, :description, :debit_account_id, :credit_account_id, :amount, :discount_amount)
    end
  end
end