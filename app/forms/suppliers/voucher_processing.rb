module Suppliers
  class VoucherProcessing
    include ActiveModel::Model
    attr_accessor :supplier_id,
                  :reference_number,
                  :date,
                  :description,
                  :preparer_id
    validates :date, :reference_number, :description, presence: true
    def process!
      create_voucher
    end

    private
    def create_voucher
      voucher = find_supplier.vouchers.create!(
        date: date,
        description: description,
        reference_number: reference_number,
        preparer: find_employee)
      find_supplier.temporary_voucher_amounts.each do |amount|
        voucher.voucher_amounts << amount
      end
    end
    def find_supplier
      Supplier.find_by_id(supplier_id)
    end
    def find_employee
      User.find_by_id(preparer_id)
    end
  end
end
