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
        delete_order
        delete_voucher
        delete_entry
      end

    end

    private 
    def delete_entry
      entry.destroy
    end

    def delete_voucher
      voucher.destroy
    end

    def delete_order
      order.destroy
    end
  end
end
