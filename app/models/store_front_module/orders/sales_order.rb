module StoreFrontModule
  module Orders
    class SalesOrder < Order

      belongs_to :receivable_account,    class_name: 'AccountingModule::Account', optional: true
      belongs_to :sales_revenue_account, class_name: 'AccountingModule::Account', optional: true
      belongs_to :sales_discount_account, class_name: 'AccountingModule::Account', optional: true

      has_one :cash_payment, as: :cash_paymentable, class_name: "StoreFrontModule::CashPayment", dependent: :destroy
      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'order_id', dependent: :destroy
      has_many :other_sales_line_items, foreign_key: 'order_id'
      delegate :name, to: :customer, prefix: true, allow_nil: true
      delegate :full_name, to: :customer, prefix: true, allow_nil: true
      delegate :balance, to: :receivable_account
      before_destroy :delete_entry

      def has_balance?
        balance > 0
      end

      def order_description
        if line_items.present?
          line_items_name
        elsif description.present?
          description
        end
      end


      def accounts_receivable_total
        default_receivable_account.debits_balance(commercial_document_id: self.id, commercial_document_type: "Order")
      end
      def payments_total
        default_receivable_account.credits_balance(commercial_document_id: self.id, commercial_document_type: "Order")
      end

      def payment_entries
        receivable_account.credit_entries
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
        elsif cash_payment.present?
          cash_payment.cash_tendered
        else
          0
        end
      end

      def total_line_items_cost
        if line_items.present?
          sales_order_line_items.sum(&:total_cost)
        else
          0
        end
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

      def default_receivable_account
        if receivable_account.blank?
          store_front.receivable_account
        else
          receivable_account
        end
      end

      def default_sales_revenue_account
        if sales_revenue_account.blank?
          store_front.sales_account
        else
          sales_revenue_account
        end
      end

      def default_sales_discount_account
        if sales_discount_account.blank?
          store_front.sales_discount_account
        else
          sales_discount_account
        end
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
