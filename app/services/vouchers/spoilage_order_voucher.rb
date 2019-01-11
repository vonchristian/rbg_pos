module Vouchers
  class SpoilageOrderVoucher
    attr_reader :order, :store_front

    def initialize(args)
      @order = args.fetch(:order)
      @store_front = @order.store_front
    end

    def create_voucher!
      voucher = Voucher.new(
        description:         "Spoilage order",
        date:                order.date,
        payee:               order.employee,
        preparer:            order.employee,
        reference_number:    SecureRandom.uuid,
        commercial_document: order,
        account_number:      order.account_number
      )
      voucher.voucher_amounts.debit.build(
        amount: order.total_cost,
        account: store_front.spoilage_account,
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
