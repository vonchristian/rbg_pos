module Employees
  class EmployeeCashAccount < ApplicationRecord
    belongs_to :employee, class_name: "User"
    belongs_to :cash_account, class_name: "AccountingModule::Account"
    def self.cash_accounts
      AccountingModule::Account.where(id: self.pluck(:cash_account_id))
    end
  end
end
