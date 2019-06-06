module ComputerRepairSection
  class WorkOrdersController < ApplicationController
    def new
      @work_order = ::WorkOrders::Registration.new
    end
    def create
      @work_order = ::WorkOrders::Registration.new(work_order_params)
      if @work_order.valid?
        @work_order.register!
        redirect_to computer_repair_section_work_order_url(@work_order.find_work_order), notice: "Work order received successfully."
      else
        render :new
      end
    end
    def show
      @work_order = WorkOrder.find(params[:id])
      @work_order_update = @work_order.work_order_updates.build
      respond_to do |format|
        format.html
        format.pdf do
          pdf = ServiceFormPdf.new(@work_order, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Service Form.pdf"
        end
      end
    end
    def edit
      @work_order = WorkOrder.find(params[:id])
    end
    def update
      @work_order = WorkOrder.find(params[:id])
      @work_order.update(update_params)
      if @work_order.save
        if @work_order.released?
          @work_order.update_attributes!(release_date: @work_order.updated_at)
        end
        redirect_to computer_repair_section_work_order_url(@work_order), notice: "Updated successfully"
      else
        render :show
      end
    end

    def destroy
      @work_order = WorkOrder.find(params[:id])
      @work_order.destroy
      redirect_to computer_repair_section_dashboard_index_url, notice: "Deleted successfully."
    end

    private
    def work_order_params
      params.require(:work_orders_registration).permit(:work_order_category_id, :date_received, :contact_person, :store_front_id, :section_id, :under_warranty, :supplier_id, :purchase_date, :expiry_date, :service_number, :status, :customer_id, :reported_problem, :physical_condition, :description, :model_number, :serial_number, :technician_id, :account_number, :department_id)
    end
    def update_params
      params.require(:work_order).
      permit(:work_order_category_id, :date_received, :contact_person, :store_front_id, :section_id, :under_warranty, :supplier_id, :purchase_date, :expiry_date, :service_number, :status, :customer_id, :reported_problem, :physical_condition, :description, :model_number, :serial_number, :technician_id, :account_number, :department_id)
    end
  end
end
