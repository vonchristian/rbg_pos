module Migrations
  class PurchaseOrder
    def initialize(orders:)
      @orders = orders
    end

    def migrate!
      orders.each do |order|
        purchase_order = StoreFronts::Orders::PurchaseOrder.build(
          voucher: order.voucher,
          employee: order.employee,
          account_number: order.account_number
        )
        create_receivable_account(purchase_order)
        purchase_order.save!
      end
    end
  end
end
