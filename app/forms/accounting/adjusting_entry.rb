module Accounting
  class AdjustingEntry
    include ActiveModel::Model
    attr_accessor :entry_date, :reference_number, :description, :employee_id, :account_number

    def process!
      voucher = Voucher.new(
        preparer: find_employee,
        payee: find_employee,
        date: entry_date,
        reference_number: reference_number,
        description: description,
        account_number: account_number
      )
      voucher.voucher_amounts << find_employee.voucher_amounts.without_voucher
      voucher.save!
      create_entry(voucher)

    end
    def find_employee
      User.find(employee_id)
    end
    def create_entry(voucher)
      VoucherEntryCreation.new(voucher: voucher).create_entry!
    end
  end
end
