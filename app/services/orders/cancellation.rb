module Orders
  class Cancellation
    attr_reader :order, :entry, :voucher

    def initialize(order:)
      @order   = order
      @voucher = @order.voucher
      @entry   = @voucher.entry
    end

    def cancel!
      ActiveRecord::Base.transaction do
        delete_stocks
        delete_order
        delete_voucher
        delete_entry
      end

    end

    private

    def delete_stocks
      order.stocks.destroy_all
    end

    def delete_entry
      if entry.present?
        entry.destroy
      end
    end

    def delete_voucher
      voucher.orders.destroy_all
      voucher.destroy
    end

    def delete_order
      order.destroy
    end
  end
end
