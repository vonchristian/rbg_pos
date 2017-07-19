module Reports 
	class SalesController < ApplicationController
		def index 
			@from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Time.zone.now.beginning_of_day
      @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now.end_of_day
			@orders = Order.created_between(from_date: @from_date, to_date: @to_date)
			respond_to do |format|
				format.pdf do 
					pdf = Reports::SalesPdf.new(@from_date, @to_date, @orders, view_context)
					send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Sales Report.pdf'
		    end
		  end
		end 
	end 
end 