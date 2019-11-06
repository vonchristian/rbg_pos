module Vouchers
  class OtherSalesOrderVoucher
    attr_reader :order, :employee, :cash_on_hand, :sales_revenue_account, :amount

    def initialize(args)
      @order                 = args.fetch(:order)
      @employee              = args.fetch(:employee)
      @amount                = args.fetch(:amount)
      @store_front           = @employee.store_front
      @cash_on_hand          = @employee.cash_on_hand_account
      @sales_revenue_account = @order.sales_revenue_account
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
        amount: amount,
        account: cash_on_hand
      )

      voucher.voucher_amounts.credit.build(
        amount: amount,
        account: sales_revenue_account
      )

    voucher.save!
    order.update!(voucher: voucher)
    end
  end
end
