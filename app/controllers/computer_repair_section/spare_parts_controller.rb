module ComputerRepairSection 
  class SparePartsController < ApplicationController
    def new 
      @work_order = WorkOrder.find(params[:work_order_id])
      @spare_part = @work_order.spare_parts.build
      @stocks = Stock.text_search(params[:search])
    @line_item = LineItem.new 
    @cart = current_cart
    @order = Order.new 
    end 
    def create
      @work_order = WorkOrder.find(params[:work_order_id])
      @spare_part = @work_order.spare_parts.create(spare_part_params)
      if @spare_part.save 
        @work_order.spare_part_entry(@spare_part)
        redirect_to new_computer_repair_section_work_order_spare_part_url(@work_order), notice: "Added successfully"
      else 
        render :new 
      end 
    end 

    private 
    def spare_part_params
      params.require(:line_item).permit(:stock_id, :unit_cost, :total_cost, :quantity, :markup_amount, :user_id)
    end
  end 
end 
