module ComputerRepairSection
  module WorkOrders
    class PaymentsController < ApplicationController
      def new 
        @work_order = WorkOrder.find(params[:work_order_id])
        @entry = AccountingModule::WorkOrderPaymentForm.new 
      end 
      def create 
        @work_order = WorkOrder.find(params[:work_order_id])
        @entry = AccountingModule::WorkOrderPaymentForm.new(entry_params)
        if @entry.valid?
          @entry.save 
          redirect_to computer_repair_section_work_order_path(@work_order), notice: "Payment saved successfully."
        else 
          render :new 
        end 
      end 

      private 
      def entry_params
        params.require(:accounting_module_work_order_payment_form).permit(:user_id, :work_order_id, :entry_date, :reference_number, :description, :debit_account_id, :credit_account_id, :amount)
      end
    end
  end
end