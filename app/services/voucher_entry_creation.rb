class VoucherEntryCreation
  attr_reader :voucher

  def initialize(args)
    @voucher = args.fetch(:voucher)
  end

  def create_entry!
    entry = AccountingModule::Entry.new(
      recorder: voucher.preparer,
      commercial_document: voucher,
      entry_date: voucher.date,
      description: voucher.description
    )
    voucher.voucher_amounts.debit.each do |amount|
      entry.debit_amounts.build(
      amount: amount.amount,
      account: amount.account,
      commercial_document: amount.commercial_document
      )
    end

    voucher.voucher_amounts.credit.each do |amount|
      entry.credit_amounts.build(
      amount: amount.amount,
      account: amount.account,
      commercial_document: amount.commercial_document
      )
    end
    entry.save!
  end
end
