module WorkOrders
  class ServiceChargeCancellation
    attr_reader :service_charge, :work_order, :employee, :customer
    def initialize(service_charge:)
      @service_charge = service_charge
      @employee       = @service_charge.user
      @work_order     = @service_charge.work_order
      @customer       = @work_order.customer
    end
    def cancel!
      ActiveRecord::Base.transaction do
        create_entry
        delete_service_charge
      end
    end
    private
    def create_entry
      accounts_receivable = work_order.receivable_account
      service_revenue = work_order.service_revenue_account
        employee.entries.create!(
          commercial_document: customer,
          entry_date: Date.current,
          description: "Cancel #{service_charge.description}",
          debit_amounts_attributes: [amount: service_charge.amount,
                                     account: service_revenue
                                     ],
            credit_amounts_attributes:[ amount: service_charge.amount,
                                        account: accounts_receivable
                                      ])
    end

    def delete_service_charge
      service_charge.destroy
    end
  end
end
