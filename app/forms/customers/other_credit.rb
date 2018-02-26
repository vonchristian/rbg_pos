module Customers
  class OtherCredit
    include ActiveModel::Model
    attr_accessor :customer_id,
                  :date,
                  :description,
                  :amount,
                  :reference_number,
                  :employee_id
    def process!
      ActiveRecord::Base.transaction do
        create_other_credit
      end
    end

    private
    def create_other_credit
      order = StoreFrontModule::Orders::SalesOrder.create(
        description: description,
        reference_number: reference_number,
        date: date,
        employee: find_employee,
        commercial_document: find_customer)

      accounts_receivable = find_employee.store_front.default_accounts_receivable_account
      other_income = find_employee.store_front.default_other_income_account
      AccountingModule::Entry.create!(
        recorder: find_employee,
        commercial_document: find_customer,
        description: description,
        reference_number: reference_number,
        entry_date: date,
        debit_amounts_attributes:
        [ amount: amount,
          account: accounts_receivable,
          commercial_document: order],
        credit_amounts_attributes: [ amount: amount,
          account: other_income,
          commercial_document: order])
    end

    def find_customer
      Customer.find_by_id(customer_id)
    end
    def find_employee
      User.find_by_id(employee_id)
    end
  end
end
