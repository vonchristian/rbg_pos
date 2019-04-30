module Orders
  class Cancellation
    attr_reader :order, :entry, :voucher

    def initialize(args)
      @order   = args.fetch(:order)
      @voucher = @order.voucher
      @entry   = @voucher.entry
    end

    def cancel!
      delete_entry
      delete_order
      delete_voucher

    end

    def delete_entry
      if entry.present?
        entry.destroy
      end
    end

    def delete_voucher
      voucher.destroy
    end

    def delete_order
      order.destroy
    end
  end
end
