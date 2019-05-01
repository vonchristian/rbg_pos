module WorkOrders
  class Registration
    include ActiveModel::Model
    attr_accessor :work_order_category_id, :date_received, :contact_person, :store_front_id, :section_id,
    :under_warranty, :supplier_id, :purchase_date, :expiry_date, :status,
    :customer_id, :reported_problem, :physical_condition, :description,
    :model_number, :serial_number, :technician_id, :account_number
    validates :date_received, :description, :date_received, :reported_problem,
    :physical_condition, :work_order_category_id, :customer_id, :model_number,presence: true
    def find_work_order
      WorkOrder.find_by(account_number: account_number)
    end
    def register!
      create_work_order
    end

    private
    def create_work_order
      work_order = WorkOrder.received.new(
        work_order_category_id: work_order_category_id,
        service_number:     WorkOrder.last.id.succ,
        date_received:      date_received,
        contact_person:     contact_person,
        store_front_id:     store_front_id,
        section_id:         section_id,
        under_warranty:     under_warranty,
        supplier_id:        supplier_id,
        purchase_date:      purchase_date,
        expiry_date:        expiry_date,
        customer_id:        customer_id,
        reported_problem:   reported_problem,
        physical_condition: physical_condition,
        account_number:     account_number,
        customer_name:      find_customer.full_name,
        product_name:       description
      )
      product_unit = ProductUnit.create!(
        description:   description,
        model_number:  model_number,
        serial_number: serial_number)
        work_order.product_unit = product_unit
      work_order.save!
      add_to_technician(work_order)
      create_accounts(work_order)
    end

    def add_to_technician(work_order)
      work_order.technician_work_orders.create!(technician: find_technician)
    end

    def find_customer
      Customer.find(customer_id)
    end

    def find_technician
      User.find(technician_id)
    end
    def create_accounts(work_order)
      AccountCreators::WorkOrder.new(work_order: work_order).create_accounts!
    end
  end
end
