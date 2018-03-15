module Reports
	class SalesController < ApplicationController
		def index
			@from_date = Chronic.parse(params[:from_date].to_date)
      @to_date = Chronic.parse(params[:to_date].to_date)
      @employee = User.find_by_id(params[:user_id])
      if @employee.present?
        @orders = @employee.orders.ordered_on(from_date: @from_date, to_date: @to_date)
      else
			  @orders = StoreFrontModule::Orders::SalesOrder.ordered_on(from_date: @from_date, to_date: @to_date)
      end
			respond_to do |format|
				format.pdf do
					pdf = Reports::SalesPdf.new(@from_date, @to_date, @orders, @employee, view_context)
					send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Sales Report.pdf'
		    end
		  end
		end
	end
end
