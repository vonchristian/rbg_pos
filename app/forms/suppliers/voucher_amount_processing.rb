module Suppliers
  class VoucherAmountProcessing
    include ActiveModel::Model
    attr_accessor :account_id, :amount, :amount_type, :supplier_id
    validates :account_id, :amount, :amount_type, presence: true
    def process!
      ActiveRecord::Base.transaction do
        create_voucher_amount
      end
    end

    private
    def create_voucher_amount
      Vouchers::VoucherAmount.create!(
      account_id:          account_id,
      amount:              amount,
      amount_type:         amount_type,
      commercial_document: find_supplier)
    end
    def find_supplier
      Supplier.find_by_id(supplier_id)
    end
  end
end
