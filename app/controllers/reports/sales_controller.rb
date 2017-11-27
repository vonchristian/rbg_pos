module Reports
	class SalesController < ApplicationController
		def index
			@from_date = Chronic.parse(params[:from_date].to_date)
      @to_date = Chronic.parse(params[:to_date].to_date)
      @user = User.find_by(id: params[:user_id])
      if @user.present?
        @orders = @user.orders.ordered_on(from_date: @from_date, to_date: @to_date)
      else
			  @orders = Order.ordered_on(from_date: @from_date, to_date: @to_date)
      end
			respond_to do |format|
				format.pdf do
					pdf = Reports::SalesPdf.new(@from_date, @to_date, @orders, @user, view_context)
					send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Sales Report.pdf'
		    end
		  end
		end
	end
end
