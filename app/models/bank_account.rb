class BankAccount < ApplicationRecord
  belongs_to :cash_in_bank_account, class_name: "AccountingModule::Account"
  belongs_to :business

  has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document

  validates :bank_name, :account_number, :cash_in_bank_account_id, presence: true
  validates :cash_in_bank_account_id, :bank_name, :account_number, uniqueness: true
  def entry_type_for(entry)
    if cash_in_bank_account.debit_entries.include?(entry)
      "Deposit"
    elsif cash_in_bank_account.credit_entries.include?(entry)
      "Withdrawal"
    end
  end
  def entry_color(entry)
    if entry_type_for(entry) == "Deposit"
      "green"
    elsif entry_type_for(entry) == "Withdrawal"
      "red"
    end
  end
  def deposits_balance
    cash_in_bank_account.debits_balance
  end
  def withdrawals_balance
    cash_in_bank_account.credits_balance
  end
  def balance
    cash_in_bank_account.balance
  end
  def deposited_payments_to_bank_account
    cash_in_bank_account.debit_amounts.where(account: cash_in_bank_account).sum(&:amount)
  end
end
