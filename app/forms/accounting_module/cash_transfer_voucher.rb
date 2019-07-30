module AccountingModule
  class CashTransferVoucher
    include ActiveModel::Model
    attr_accessor :date, :employee_id, :reference_number, :description, :debit_account_id, :credit_account_id, :amount, :account_number

    def find_voucher
      Voucher.find_by!(account_number: account_number)
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
      voucher = Voucher.create!(
        account_number: account_number,
        payee: find_employee,
        reference_number: reference_number,
        description: description
      )
      voucher.voucher_amounts.debit.build(
        amount: amount,
        account_id: debit_account_id
      )

      voucher.voucher_amounts.credit.build(
        amount: amount,
        account_id: credit_account_id
      )
      voucher.save!
    end

    def find_employee
      User.find(employee_id)
    end
  end
end
