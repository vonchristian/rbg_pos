module Vouchers
  class VoucherAmountProcessingsController < ApplicationController
    def new
      @voucher_amount = Vouchers::VoucherAmountProcessing.new
    end
  end
end
