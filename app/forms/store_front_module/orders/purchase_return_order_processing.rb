module StoreFrontModule
  module Orders
    class PurchaseReturnOrderProcessing
      include ActiveModel::Model
      attr_accessor  :cart_id, :supplier_id, :voucher_id, :employee_id, :date, :description
      validates :supplier_id, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_purchase_order
        end
      end

      private
      def create_purchase_order
        order = find_supplier.purchase_return_orders.create!(
          date: date,
          employee_id: employee_id,
          search_term: find_supplier.business_name,
          description: description)
        find_cart.purchase_return_order_line_items.each do |line_item|
          line_item.cart_id = nil
          order.purchase_return_order_line_items << line_item
        end
        create_entry(order)
      end
      def find_supplier
        Supplier.find_by_id(supplier_id)
      end
      def find_cart
        Cart.find_by_id(cart_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      def create_entry(order)
        merchandise_inventory = find_employee.store_front.merchandise_inventory_account
        accounts_payable = find_supplier.default_accounts_payable_account
        find_employee.entries.create!(
          recorder: find_employee,
          commercial_document: find_supplier,
          entry_date: date,
          description: description,
          debit_amounts_attributes: [amount: order.total_cost,
                                        account: accounts_payable,
                                        commercial_document: order
                                      ],
            credit_amounts_attributes:[ amount: order.total_cost,
                                        account: merchandise_inventory,
                                        commercial_document: order
                                     ])
      end
    end
  end
end
