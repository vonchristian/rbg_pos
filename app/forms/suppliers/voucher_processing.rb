module Suppliers
  class VoucherProcessing
    include ActiveModel::Model
    attr_accessor :supplier_id,
                  :reference_number,
                  :date,
                  :description,
                  :preparer_id,
                  :cart_id,
                  :account_number
    validates :date, :reference_number, :account_number,  :description, :supplier_id, :preparer_id, :cart_id, presence: true
    def find_voucher
      find_supplier.vouchers.find_by(account_number: account_number)
    end
    def process!
      if valid?
        ActiveRecord::Base.transaction do
          create_voucher
        end
      end
    end

    private
    def create_voucher
      voucher = find_supplier.vouchers.create!(
        date:             date,
        account_number:   account_number,
        description:      description,
        reference_number: reference_number,
        preparer:         find_employee)
      find_cart.voucher_amounts.each do |amount|
        voucher.voucher_amounts << amount
        amount.cart_id = nil
        amount.save!
      end
    end

    def find_supplier
      Supplier.find(supplier_id)
    end

    def find_cart
      Cart.find(cart_id)
    end

    def find_employee
      User.find(preparer_id)
    end
  end
end
