module StoreFrontModule
  module Orders
    class StockTransferOrderProcessingsController < ApplicationController
      def create
        @stock_transfer_order = StoreFrontModule::Orders::StockTransferOrderProcessing.new(order_params)
        if @stock_transfer_order.valid?
          ActiveRecord::Base.transaction do
            @stock_transfer_order.process!
            @processed_order = @stock_transfer_order.find_order
            create_voucher
            create_entry
          end
          redirect_to store_front_module_stock_transfers_url, notice: " Stock Transfer Order saved successfully."
        else
          redirect_to new_store_front_module_stock_transfer_order_line_item_processing_url, alert: "Error"
        end
      end
      private
      def order_params
        params.require(:store_front_module_orders_stock_transfer_order_processing).
        permit(:origin_store_front_id,
               :destination_store_front_id,
               :account_number,
               :registry_id,
               :date,
               :employee_id,
               :cart_id,
               :description,
               :reference_number)
      end
      def create_voucher
        Vouchers::StockTransferOrderVoucher.new(
          order:    @processed_order,
          origin_store_front:   current_user.store_front,
          employee: current_user).
          create_voucher!
      end

      def create_entry
        VoucherEntryCreation.new(voucher: Voucher.find_by(account_number: @processed_order.account_number)).create_entry!
      end
    end
  end
end
