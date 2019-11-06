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
      order = StoreFrontModule::Orders::SalesOrder.create!(
        store_front: find_employee.store_front,
        account_number: SecureRandom.uuid,
        description: description,
        reference_number: reference_number,
        date: date,
        employee: find_employee,
        commercial_document: find_customer)
        order.other_sales_line_items.create(
          description:      description,
          reference_number: reference_number,
          date:             date,
          amount:           amount
        )

        create_accounts(order)
        create_entry(order)
    end

    def create_accounts(order)
      AccountCreators::SalesOrder.new(sales_order: order).create_accounts!
    end

    def create_entry(order)
      AccountingModule::Entry.create!(
        recorder: find_employee,
        commercial_document: find_customer,
        description: description,
        reference_number: reference_number,
        entry_date: date,
        debit_amounts_attributes:
        [ amount: amount,
          account: order.receivable_account],
        credit_amounts_attributes: [ amount: amount,
          account: order.sales_revenue_account])
    end
    def find_customer
      Customer.find_by_id(customer_id)
    end
    def find_employee
      User.find_by_id(employee_id)
    end
  end
end
