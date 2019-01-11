module Vouchers
  class SalesReturnOrderVoucher
    attr_reader :order, :cash_account, :store_front, :employee

    def initialize(args)
      @order = args.fetch(:order)
      @store_front = @order.store_front
      @employee = @order.employee
      @cash_account = args[:cash_account]
    end

    def create_voucher!
      voucher = Voucher.new(
        description: "Sales return order",
        date:                order.date,
        payee:               order.customer,
        preparer:            order.employee,
        reference_number:    order.reference_number,
        commercial_document: order,
        account_number:      order.account_number
      )

      voucher.voucher_amounts.credit.build(
      amount:              order.total_cost,
      account:             applicable_account,
      commercial_document: order
      )

      voucher.voucher_amounts.credit.build(
      amount:              order.total_cost,
      account:             store_front.cost_of_goods_sold_account,
      commercial_document: order
      )

      voucher.voucher_amounts.debit.build(
      amount:              order.total_cost,
      account:             store_front.merchandise_inventory_account,
      commercial_document: order
      )

      voucher.voucher_amounts.debit.build(
      amount:              order.total_cost,
      account:             store_front.sales_return_account,
      commercial_document: order
      )

      voucher.save!
      order.update_attributes!(voucher: voucher)
    end

    def applicable_account
      if order.credit?
        store_front.receivable_account
      else
        cash_account
      end
    end
  end
end
