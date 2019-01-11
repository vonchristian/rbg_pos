module Vouchers
  class PurchaseReturnOrderVoucher
    attr_reader :order, :store_front

    def initialize(args)
      @order = args.fetch(:order)
      @store_front = @order.store_front
    end

    def create_voucher!
      voucher = Voucher.new(
        description:         "Purchase return order",
        date:                order.date,
        payee:               order.supplier,
        preparer:            order.employee,
        reference_number:    SecureRandom.uuid,
        commercial_document: order,
        account_number:      order.account_number
      )
      voucher.voucher_amounts.debit.build(
        amount: order.total_cost,
        account: store_front.purchase_return_account,
        commercial_document: order
      )
      voucher.voucher_amounts.credit.build(
        amount: order.total_cost,
        account: store_front.merchandise_inventory_account,
        commercial_document: order
      )
      voucher.save!
      order.update_attributes!(voucher: voucher)
    end
  end
end
