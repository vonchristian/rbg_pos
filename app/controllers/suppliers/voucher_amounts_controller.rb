module Suppliers
  class VoucherAmountsController < ApplicationController
    def new
      @supplier = Supplier.find(params[:supplier_id])
      @voucher_amount = Suppliers::VoucherAmountProcessing.new
      @voucher = Suppliers::VoucherProcessing.new
    end
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @voucher_amount = Suppliers::VoucherAmountProcessing.new(voucher_amount_params)
      if @voucher_amount.valid?
        @voucher_amount.process!
        redirect_to new_supplier_voucher_amount_url(@supplier), notice: "added successfully"
      else
        render :new
      end
    end

    private
    def voucher_amount_params
      params.require(:suppliers_voucher_amount_processing).permit(
        :amount,
        :account_id,
        :amount_type,
        :supplier_id,
        :cart_id)
    end
  end
end
