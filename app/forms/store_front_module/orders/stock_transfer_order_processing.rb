module StoreFrontModule
  module Orders
    class StockTransferOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id,
                     :employee_id,
                     :account_number,
                     :date,
                     :description,
                     :destination_store_front_id,
                     :registry_id,
                     :reference_number
      validates :destination_store_front_id, :reference_number, :date, presence: true

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
        order = StoreFrontModule::Orders::PurchaseOrder.create!(
          credit: true,
          date:                    date,
          description:             reference_number,
          employee:                find_employee,
          account_number:          SecureRandom.uuid,
          commercial_document:     find_employee.store_front,
          store_front:             find_employee.store_front,
          supplier:                find_employee.store_front,
          search_term:             find_destination_store_front.name,
          destination_store_front_id: destination_store_front_id,
          reference_number:        reference_number)

          find_cart.purchase_order_line_items.each do |line_item|
            line_item.update_attributes!(date: date)
            line_item.cart_id = nil
            order.purchase_order_line_items << line_item
            create_stock(line_item)
          end

          find_cart.stock_transfer_order_line_items.where(order_id: nil).each do |line_item|
            line_item.update_attributes!(order_id: order.id)
          end

          if find_registry.present?
            find_registry.purchase_order_line_items.each do |line_item|
              line_item.update_attributes!(date: date)
              line_item.cart_id = nil
              order.purchase_order_line_items << line_item

            end
          end
          create_voucher(order)
          create_entry(order)
      end

      def create_stock(line_item)
        ::StoreFronts::StockTransfers::StockCreation.new(line_item: line_item, destination_store_front: find_destination_store_front).create_stock!
      end


      def find_destination_store_front
        StoreFront.find(destination_store_front_id)
      end
      def find_cart
        Cart.find(cart_id)
      end
      def find_registry
        Registry.find_by(id: registry_id)
      end
      def find_employee
        User.find(employee_id)
      end

      def create_voucher(order)
        Vouchers::PurchaseOrderVoucher.new(
          order:    order,
          employee: order.employee).
          create_voucher!
      end

      def create_entry(order)
        VoucherEntryCreation.new(voucher: order.voucher).create_entry!
      end
    end
  end
end
