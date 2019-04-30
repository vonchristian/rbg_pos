module AccountCreators
  class WorkOrder
    attr_reader :work_order, :business, :customer
    def initialize(args={})
      @work_order = args.fetch(:work_order)
      @business   = @work_order.business
      @customer   = @work_order.customer
    end
    def create_accounts!
      create_receivable_account
      create_sales_revenue_account
      create_sales_discount_account
      create_service_revenue_account
    end

    private

    def create_receivable_account
      account = AccountingModule::Asset.create!(
        business:     business,
        name:         receivable_account_name,
        account_code: SecureRandom.uuid)
      work_order.update(receivable_account: account)
      customer.receivable_account.sub_accounts.create(sub_account: account)
    end

    def create_sales_revenue_account
      account = AccountingModule::Revenue.create!(
        business:     business,
        name:         sales_revenue_account_name,
        account_code: SecureRandom.uuid)
      work_order.update(sales_revenue_account: account)
      customer.sales_revenue_account.sub_accounts.create(sub_account: account)
    end

    def create_sales_discount_account
      account = AccountingModule::Revenue.create!(
        contra:       true,
        business:     business,
        name:         sales_discount_account_name,
        account_code: SecureRandom.uuid)
      work_order.update(sales_discount_account: account)
      customer.sales_discount_account.sub_accounts.create(sub_account: account)
    end

    def create_service_revenue_account
      account = AccountingModule::Revenue.create!(
        business:     business,
        name:         service_revenue_account_name,
        account_code: SecureRandom.uuid)
      work_order.update(service_revenue_account: account)
      customer.service_revenue_account.sub_accounts.create(sub_account: account)
    end

    def receivable_account_name
      "Accounts Receivable Work Orders - #{work_order.customer_name} ##{work_order.service_number}"
    end

    def sales_revenue_account_name
      "Sales (Work Orders) - #{work_order.customer_name} ##{work_order.service_number}"
    end

    def sales_discount_account_name
      "Sales Discounts (Work Orders) - #{work_order.customer_name} ##{work_order.service_number}"
    end

    def service_revenue_account_name
      "Service Income - #{work_order.customer_name} ##{work_order.service_number}"
    end
  end
end
