module StoreFrontModule
  module Orders
    class SalesOrderProcessingsController < ApplicationController
      def create
        @sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
        if @sales_order.process!
          @sales_order.process!
          redirect_to store_index_url, notice: "Order saved successfully."
        else
          redirect_to store_index_url, alert: "Error"
        end
      end

      private
      def order_params
        params.require(:store_front_module_orders_sales_order_processing).
        permit(:customer_id, :date, :cash_tendered, :order_change, :employee_id, :cart_id, :reference_number)
      end
    end
  end
end

