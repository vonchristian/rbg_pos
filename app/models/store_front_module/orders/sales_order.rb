module StoreFrontModule
  module Orders
    class SalesOrder < Order

      has_one :cash_payment, as: :cash_paymentable, class_name: "StoreFrontModule::CashPayment", dependent: :destroy
      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'order_id', dependent: :destroy
      has_many :other_sales_line_items, foreign_key: 'order_id'
      delegate :name, to: :customer, prefix: true, allow_nil: true
      delegate :full_name, to: :customer, prefix: true, allow_nil: true

      before_destroy :delete_entryz

      def has_balance?
        balance > 0
      end
      def balance
        StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.balance(commercial_document_id: self.id, commercial_document_type: "Order")
      end

      def accounts_receivable_total
        StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.debits_balance(commercial_document_id: self.id, commercial_document_type: "Order")
      end
      def payments_total
        StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.credits_balance(commercial_document_id: self.id, commercial_document_type: "Order")
      end
      def payment_entries
        ids = StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.credit_amounts.where(commercial_document: self).pluck(:entry_id)
        AccountingModule::Entry.where(id: ids)
      end


      def customer
        commercial_document
      end
      def name
        customer.full_name
      end
      def cost_of_goods_sold
        sales_order_line_items.cost_of_goods_sold
      end
      def total_cost
        if line_items.present? || other_sales_line_items.present?
          total_line_items_cost +
          other_sales_line_items.total_cost
        else
          cash_payment_cash_tendered
        end
      end

      def total_line_items_cost
        if line_items.present?
          sales_order_line_items.sum(&:total_cost)
        else
          0
        end
      end
      def income
        total_cost - cost_of_goods_sold
      end
      def self.caret_status
        "up"
      end
      def self.percentage_text_color
        "green"
      end
      def destroy_entry!
        if payment_entries.present?
          payment_entries.destroy_all
        end
      end

      def destroy_work_order_entry!
      end
      private
      def delete_entry
        if payment_entries.present?
          payment_entries.destroy_all
        end
      end
    end
  end
end
