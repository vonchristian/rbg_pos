module ComputerRepairSection 
  module WorkOrders 
    class EndorsementsController < ApplicationController 
      def edit
        @work_order = current_store_front.work_orders.find(params[:work_order_id])
      end 

      def update
        @work_order = current_store_front.work_orders.find(params[:work_order_id])
        @work_order.update(technician_id: params[:technician_id])
        redirect_to computer_repair_section_work_order_url(@work_order), notice: 'saved successfully.'
      end 
    end 
  end 
end 