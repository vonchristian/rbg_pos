module Suppliers
  class VoucherConfirmation
    include ActiveModel::Model
    attr_accessor :supplier_id, :voucher_id

    def confirm!
      disburse_voucher
    end

    private
    def disburse_voucher
      Vouchers::EntryProcessing.new(voucher: find_voucher).create_entry!
    end
    
    def find_voucher
      Voucher.find(voucher_id)
    end
  end
end
