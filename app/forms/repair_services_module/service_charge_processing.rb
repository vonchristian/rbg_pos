module RepairServicesModule
  class ServiceChargeProcessing
    include ActiveModel::Model
    attr_accessor :description, :amount, :employee_id, :date, :work_order_id, :customer_id
    validates :description, :amount, :date, presence: true
    validates :amount, numericality: true
    def process!
      ActiveRecord::Base.transaction do
        create_service_charge
      end
    end

    private
    def create_service_charge
      charge = ServiceCharge.create(description: description, amount: amount)
      service_charge = find_work_order.work_order_service_charges.find_or_create_by(service_charge: charge, user: find_employee)
      create_entry(service_charge)
    end
    def create_entry(service_charge)
      accounts_receivable = find_work_order.store_front.receivable_account
      services_revenue = find_work_order.store_front.service_revenue_account
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_customer,
          entry_date: date,
          description: description,
          debit_amounts_attributes: [amount: service_charge.amount,
                                        account: accounts_receivable,
                                        commercial_document: service_charge
                                     ],
            credit_amounts_attributes:[ amount: service_charge.amount,
                                        account: services_revenue,
                                        commercial_document: service_charge
                                      ])
    end

    def find_employee
      User.find_by_id(employee_id)
    end
    def find_work_order
      WorkOrder.find_by_id(work_order_id)
    end
    def find_customer
      Customer.find_by_id(customer_id)
    end
  end
end
