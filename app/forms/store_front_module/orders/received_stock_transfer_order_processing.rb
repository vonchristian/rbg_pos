module StoreFrontModule
  module Orders
    class ReceivedStockTransferOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id,
                     :origin_store_front_id,
                     :employee_id,
                     :date,
                     :description,
                     :destination_store_front_id,
                     :registry_id,
                     :reference_number
      validates :destination_store_front_id, :reference_number, :date, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_stock_transfer_order
        end
      end

      private
      def create_stock_transfer_order
        order = StoreFrontModule::Orders::ReceivedStockTransferOrder.create!(
          date: date,
          description: reference_number,
          employee_id: employee_id,
          commercial_document: find_store_front,
          search_term: find_destination_store_front.name,
          destination_store_front: find_destination_store_front,
          reference_number: reference_number)
        find_cart.purchase_order_line_items.each do |line_item|
          line_item.update_attributes!(date: date)
          line_item.cart_id = nil
          order.purchase_order_line_items << line_item
        end
        if find_registry.present?
          find_registry.purchase_order_line_items.each do |line_item|
            line_item.update_attributes!(date: date)
            line_item.cart_id = nil
            order.purchase_order_line_items << line_item
          end
        end
        create_entry(order)
      end
      def find_store_front
        StoreFront.find_by_id(origin_store_front_id)
      end
      def find_destination_store_front
        StoreFront.find_by_id(destination_store_front_id)
      end
      def find_cart
        Cart.find_by_id(cart_id)
      end
      def find_registry
        Registry.find_by_id(registry_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end

      def create_entry(order)
        origin_store_front_inventory = find_employee.store_front.merchandise_inventory_account
        destination_store_front_inventory = find_destination_store_front.merchandise_inventory_account
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_store_front,
          entry_date: date,
          description: "stock transfer to #{find_destination_store_front.name}",
          debit_amounts_attributes: [amount: order.total_cost,
                                        account: destination_store_front_inventory
                                      ],
            credit_amounts_attributes:[ amount: order.total_cost,
                                        account: origin_store_front_inventory
                                     ])
      end
    end
  end
end
