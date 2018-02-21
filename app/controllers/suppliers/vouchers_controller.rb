module Suppliers
  class VouchersController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
      @vouchers = @supplier.vouchers
    end
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @voucher = Suppliers::VoucherProcessing.new(voucher_params)
      if @voucher.valid?
        @voucher.process!
        redirect_to supplier_vouchers_url(@supplier), notice: "Voucher created successfully."
      else
        render :new
      end
    end

    private
    def voucher_params
      params.require(:suppliers_voucher_processing).permit(
      :supplier_id,
      :reference_number,
      :date,
      :description,
      :preparer_id)
    end
  end
end
