module AccountCreators
  class SalesOrder
    attr_reader :sales_order, :business, :customer
    def initialize(args)
      @sales_order = args.fetch(:sales_order)
      @business    = @sales_order.store_front.business
      @customer    = @sales_order.commercial_document
    end
    def create_accounts!
      create_receivable_account
      create_sales_revenue_account
      create_sales_discount_account
    end

    private
    def create_receivable_account
      if sales_order.receivable_account.blank?
        account = AccountingModule::Asset.create!(
        business:     business,
        name:         receivable_account_name,
        account_code: SecureRandom.uuid)
        sales_order.update(receivable_account: account)

      end
    end

    def create_sales_revenue_account
      if sales_order.sales_revenue_account.blank?
        account = AccountingModule::Revenue.create!(
        business:     business,
        name:         sales_revenue_account_name,
        account_code: SecureRandom.uuid)
        sales_order.update(sales_revenue_account: account)

      end
    end

    def create_sales_discount_account
      if sales_order.sales_discount_account.blank?
        account = AccountingModule::Revenue.create!(
        contra:       true,
        business:     business,
        name:         sales_discount_account_name,
        account_code: SecureRandom.uuid)
        sales_order.update(sales_discount_account: account)
      end
    end

    def receivable_account_name
      "Accounts Receivable Sales Orders - #{sales_order.customer_name} ##{sales_order.account_number}"
    end

    def sales_revenue_account_name
      "Sales Orders - #{sales_order.customer_name} ##{sales_order.account_number}"
    end

    def sales_discount_account_name
      "Sales Order Discounts - #{sales_order.customer_name} ##{sales_order.account_number}"
    end
  end
end
