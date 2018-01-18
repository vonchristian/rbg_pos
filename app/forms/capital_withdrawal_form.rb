class CapitalWithdrawalForm
  include ActiveModel::Model
  include ActiveModel::Callbacks
  attr_accessor :employee_id, :date, :amount

  validates :date, :amount, presence: true
  validates :amount, numericality: true

  def save
    ActiveRecord::Base.transaction do
      save_withdraw
    end
  end
  def find_employee
    User.find_by_id(employee_id)
  end
  private
  def save_withdraw
    AccountingModule::Entry.create!(recorder_id: employee_id, entry_type: 'owner_withdraw', commercial_document: find_employee, entry_date: date, description: "Owner Withdrawal",
          debit_amounts_attributes: [amount: amount, account: debit_account],
          credit_amounts_attributes:[amount: amount, account: credit_account])
  end

  def debit_account
    AccountingModule::Equity.find_by(account_code: 30800, name: 'Drawings Account')
  end

  def credit_account
   find_employee.cash_on_hand_account
  end
end
