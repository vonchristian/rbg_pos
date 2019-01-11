module Vouchers
  class PurchaseOrderVoucher
    attr_reader :order, :cash_account, :store_front, :employee, :supplier
    def initialize(args)
      @order        = args.fetch(:order)
      @cash_account = args[:cash_account]
      @store_front  = @order.store_front
      @employee     = @order.employee
      @supplier     = @order.supplier
    end
    def create_voucher!
      voucher = Voucher.new(
        description:         "Cash purchase order",
        date:                order.date,
        payee:               order.supplier,
        preparer:            order.employee,
        reference_number:    SecureRandom.uuid,
        commercial_document: order,
        account_number:      order.account_number
      )
      voucher.voucher_amounts.debit.build(
        amount: order.total_cost,
        account: store_front.merchandise_inventory_account,
        commercial_document: order
      )
      voucher.voucher_amounts.credit.build(
        amount: order.total_cost,
        account: applicable_account,
        commercial_document: order
      )
      voucher.save!
      order.update_attributes!(voucher: voucher)
    end

    def applicable_account
      if order.credit?
        supplier.payable_account
      else
        cash_account
      end
    end
  end
end
