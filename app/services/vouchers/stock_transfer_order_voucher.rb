module Vouchers
  class StockTransferOrderVoucher

    attr_reader :order, :origin_store_front, :destination_store_front

    def initialize(args={})
      @order                   = args.fetch(:order)
      @employee                = args.fetch(:employee)
      @origin_store_front             = @order.store_front
      @destination_store_front = @order.destination_store_front
    end

    def create_voucher!
      voucher = Voucher.new(
        description: "Stock transfer order",
        date:                order.date,
        payee:               order.destination_store_front,
        preparer:            order.employee,
        reference_number:    order.reference_number,
        commercial_document: order,
        account_number:      order.account_number
      )
      voucher.voucher_amounts.debit.build(
        amount: order.total_cost,
        account: destination_store_front.merchandise_inventory_account,
        commercial_document: order
      )

      voucher.voucher_amounts.credit.build(
        amount: order.total_cost,
        account: origin_store_front.merchandise_inventory_account,
        commercial_document: order
      )
    voucher.save!
    order.update_attributes!(voucher: voucher)
    end
  end
end
