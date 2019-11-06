module Vouchers
  class DisbursementProcessing
    include ActiveModel::Model
    attr_accessor :date,
                  :disburser_id,
                  :amount,
                  :description,
                  :voucher_id
    validates :date, :amount, :description, presence: true
    def disburse!
      entry = AccountingModule::Entry.new(commercial_document: find_voucher, :description => description, recorder_id: disburser_id, entry_date: date)
      find_voucher.voucher_amounts.debit.each do |amount|
        debit_amount = AccountingModule::DebitAmount.new(account_id: amount.account_id, amount: amount.amount)
        entry.debit_amounts << debit_amount
      end
      find_voucher.voucher_amounts.credit.each do |amount|
        credit_amount = AccountingModule::CreditAmount.new(account_id: amount.account_id , amount: amount.amount)
        entry.credit_amounts << credit_amount
      end
      entry.save!
    end

    def find_voucher
      Voucher.find_by_id(voucher_id)
    end
    def find_disburser
      User.find_by_id(disburser_id)
    end
  end
end
