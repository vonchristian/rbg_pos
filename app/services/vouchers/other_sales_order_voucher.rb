module Vouchers
  class OtherSalesOrderVoucher
    attr_reader :order, :employee, :cash_on_hand, :sales

    def initialize(args)
      @order                 = args.fetch(:order)
      @employee              = args.fetch(:employee)
      @store_front           = @employee.store_front
      @cash_on_hand          = @employee.cash_on_hand_account
      @sales                 = @store_front.sales_account
    end
    def create_voucher!
      voucher = Voucher.new(
        description: "Sales",
        date: order.date,
        payee: order.customer,
        preparer: order.employee,
        reference_number: SecureRandom.uuid,
        commercial_document: order,
        account_number: order.account_number
      )
      voucher.voucher_amounts.debit.build(
        amount: order.total_cost,
        account: cash_on_hand,
        commercial_document: order
      )

      voucher.voucher_amounts.credit.build(
        amount: order.total_cost,
        account: sales,
        commercial_document: order
      )

    voucher.save!
    order.update_attributes!(voucher: voucher)
    end
  end
end
