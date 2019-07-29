module Suppliers
  class PurchaseOrder
    include ActiveModel::Model
    attr_accessor :date, :voucher_id, :supplier_id, :cart_id, :account_number, :employee_id, :store_front_id
    def process!
      if valid?
        ActiveRecord::Base.transaction do
          create_purchase_order
        end
      end
    end
    private
    def create_purchase_order
      order = find_supplier.purchase_orders.create!(
        date: date,
        voucher_id: voucher_id,
        account_number: account_number,
        store_front_id: store_front_id,
        employee_id: employee_id
      )
      find_cart.purchase_order_line_items.each do |line_item|
        order.purchase_order_line_items << line_item
        line_item.cart_id = nil
        line_item.save!
      end
    end
    def find_cart
      Cart.find(cart_id)
    end

    def find_supplier
      Supplier.find(supplier_id)
    end
  end
end
