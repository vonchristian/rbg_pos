module StoreFrontModule
  module Orders
    class PurchaseOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id, :supplier_id, :voucher_id, :employee_id, :date, :registry_id
      validates :voucher_id, :supplier_id, :cart_id, presence: true
      # validate :amounts_cancel?


      def process!
        ActiveRecord::Base.transaction do
          create_purchase_order
        end
      end

      private
      def create_purchase_order
        order = StoreFrontModule::Orders::PurchaseOrder.create!(
          supplier: find_supplier,
          date: date,
          store_front: find_employee.store_front,
          account_number: SecureRandom.uuid,
          voucher: find_voucher,
          search_term: find_supplier.business_name,
          employee: find_employee)
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
      end
      def find_supplier
        Supplier.find(supplier_id)
      end
      def find_voucher
        Voucher.find_by_id(voucher_id)
      end
      def find_cart
        Cart.find_by_id(cart_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      def find_registry
        StoreFrontModule::Registries::PurchaseOrderRegistry.find_by_id(registry_id)
      end

      private
      # def amounts_cancel?
      #     errors[:voucher_id] << "The total amount and voucher amount is not equal" if find_voucher.total != find_cart.purchase_order_line_items.sum(&:total_cost)
      # end

    end
  end
end
