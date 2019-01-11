module StoreFrontModule
  module Orders
    class StockTransferOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id,
                     :origin_store_front_id,
                     :employee_id,
                     :account_number,
                     :date,
                     :description,
                     :destination_store_front_id,
                     :registry_id,
                     :reference_number
      validates :destination_store_front_id, :origin_store_front_id, :reference_number, :date, presence: true

      def find_order
        StoreFrontModule::Orders::StockTransferOrder.find_by(account_number: account_number)
      end

      def process!
        ActiveRecord::Base.transaction do
          create_stock_transfer_order
        end
      end

      private
      def create_stock_transfer_order
        order = StoreFrontModule::Orders::StockTransferOrder.create!(
          date:                    date,
          description:             reference_number,
          employee:                find_employee,
          account_number:          account_number,
          commercial_document:     find_store_front,
          search_term:             find_destination_store_front.name,
          destination_store_front: find_destination_store_front,
          store_front:             find_employee.store_front,
          reference_number:        reference_number)
        find_cart.stock_transfer_order_line_items.each do |line_item|
          line_item.update_attributes!(date: date)
          line_item.cart_id = nil
          order.stock_transfer_order_line_items << line_item
        end
        if find_registry.present?
          find_registry.stock_transfer_order_line_items.each do |line_item|
            line_item.update_attributes!(date: date)
            line_item.cart_id = nil
            order.stock_transfer_order_line_items << line_item
          end
        end

      end
      def find_store_front
        StoreFront.find(origin_store_front_id)
      end
      def find_destination_store_front
        StoreFront.find(destination_store_front_id)
      end
      def find_cart
        Cart.find(cart_id)
      end
      def find_registry
        Registry.find_by_id(registry_id)
      end
      def find_employee
        User.find(employee_id)
      end
    end
  end
end
