module StoreFrontModule
  module Orders
    class SpoilageOrderProcessing
      include ActiveModel::Model
      include ActiveModel::Validations
      attr_accessor  :date,
                     :employee_id,
                     :cart_id,
                     :description,
                     :reference_number

      validates :cart_id,
      :employee_id,
      :description,
      :date,
      presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_order
        end
      end
       def find_cart
        Cart.find_by(id: cart_id)
      end
      private
      def create_order
          order = StoreFrontModule::Orders::SpoilageOrder.create(
          date: date,
          description: description,
          employee: find_employee,
          commercial_document: find_employee,
          reference_number: reference_number)
          find_cart.spoilage_order_line_items.each do |line_item|
            line_item.cart_id = nil
            order.spoilage_order_line_items << line_item
          create_entry(order)
        end
      end

      def find_employee
        User.find_by_id(employee_id)
      end

      def create_entry(order)
        store_front = find_employee.store_front
        spoilages = store_front.default_spoilages_account
        merchandise_inventory = store_front.merchandise_inventory_account
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_employee,
          entry_date: order.date,
          description: description,
          credit_amounts_attributes: [amount: order.total_cost,
                                        account: merchandise_inventory,
                                        commercial_document: order
                                       ],
            debit_amounts_attributes:[amount: order.total_cost,
                                        account: spoilages,
                                        commercial_document: order
                                      ])
      end
    end
  end
end
