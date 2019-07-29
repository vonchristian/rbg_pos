module Suppliers
  class VoucherAggregator
    attr_reader :supplier, :vouchers, :purchase_orders
    def initialize(supplier:)
      @supplier        = supplier
      @vouchers        = @supplier.vouchers
      @purchase_orders = @supplier.purchase_orders
    end

    def unused_vouchers
      ids = purchase_orders.pluck(:voucher_id)
      vouchers.where.not(id: ids)
    end
  end
end
