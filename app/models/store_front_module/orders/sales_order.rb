module StoreFrontModule
  module Orders
    class SalesOrder < Order
      has_one :cash_payment, as: :cash_paymentable, class_name: "StoreFrontModule::CashPayment"
      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'order_id'

      delegate :name, to: :customer, prefix: true, allow_nil: true
      delegate :discount_amount, to: :cash_payment, allow_nil: true
      def credit?
        balance.present?
      end
      def has_balance?
        balance > 0
      end
      def balance
        StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.balance(commercial_document_id: self.id)
      end
      def accounts_receivable_total
        StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.debits_balance(commercial_document_id: self.id)
      end
      def payments_total
        StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.credits_balance(commercial_document_id: self.id)
      end
      def payment_entries
        StoreFrontModule::StoreFrontConfig.new.default_accounts_receivable_account.credit_amounts.where(commercial_document: self)
      end


      def customer
        commercial_document
      end
      def cost_of_goods_sold
        sales_order_line_items.cost_of_goods_sold
      end
      def total_cost
        sales_order_line_items.sum(&:total_cost)
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
    end
  end
end
