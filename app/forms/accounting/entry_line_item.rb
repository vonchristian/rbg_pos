module Accounting
  class EntryLineItem
    include ActiveModel::Model
    attr_accessor :amount, :account_id, :amount_type, :employee_id

    def process!
      create_voucher_amount
    end

    private
    def create_voucher_amount
      Vouchers::VoucherAmount.create!(
        amount:              amount,
        account_id:          account_id,
        amount_type:         amount_type,
        commercial_document: find_employee,
        recorder:            find_employee
      )
    end
    def find_employee
      User.find(employee_id)
    end
  end
end
