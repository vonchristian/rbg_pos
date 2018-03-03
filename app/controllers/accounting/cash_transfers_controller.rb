module Accounting
  class CashTransfersController < ApplicationController
    def new
      @employee = User.find(params[:employee_id])
      @cash_transfer = AccountingModule::RemittanceForm.new
    end
    def create
      @employee = User.find(params[:employee_id])
      @cash_transfer = AccountingModule::RemittanceForm.new(cash_transfer_params)
      if @cash_transfer.valid?
        @cash_transfer.save
        redirect_to employee_url(@employee), notice: "Cash Transfer saved successfully."
      else
        render :new
      end
    end

    private
    def cash_transfer_params
      params.require(:accounting_module_remittance_form).
      permit(:recorder_id, :cashier_id, :entry_date, :reference_number, :description, :amount, :debit_account_id, :credit_account_id)
    end
  end
end
