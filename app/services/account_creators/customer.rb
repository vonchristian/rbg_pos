module AccountCreators
  class Customer
    attr_reader :customer, :business
    def initialize(args={})
      @customer   = args.fetch(:customer)
      @business   = @customer.business
    end
    def create_accounts!
      create_receivable_account
      create_sales_revenue_account
      create_sales_discount_account
      create_service_revenue_account
    end

    def create_receivable_account
      if customer.receivable_account.blank?
        account = AccountingModule::Asset.create!(
        business:     business,
        name:         receivable_account_name,
        account_code: SecureRandom.uuid)
        customer.update(receivable_account: account)
      end
    end

    def create_sales_revenue_account
      if customer.sales_revenue_account.blank?
        account = AccountingModule::Revenue.create!(
        business:     business,
        name:         sales_revenue_account_name,
        account_code: SecureRandom.uuid)
        customer.update(sales_revenue_account: account)
      end
    end

    def create_sales_discount_account
      if customer.sales_discount_account.blank?
        account = AccountingModule::Revenue.create!(
        contra:      true,
        business:     business,
        name:         sales_discount_account_name,
        account_code: SecureRandom.uuid)
        customer.update(sales_discount_account: account)
      end
    end

    def create_service_revenue_account
      if customer.service_revenue_account.blank?
        account = AccountingModule::Revenue.create!(
        business:     business,
        name:         service_revenue_account_name,
        account_code: SecureRandom.uuid)
        customer.update(service_revenue_account: account)
      end 
    end

    def receivable_account_name
      "Accounts Receivable - #{customer.full_name} - ##{customer.account_number}"
    end

    def sales_revenue_account_name
      "Sales - #{customer.full_name} - ##{customer.account_number}"
    end

    def sales_discount_account_name
      "Sales Discounts - #{customer.full_name} - ##{customer.account_number}"
    end

    def service_revenue_account_name
      "Service Income - #{customer.full_name} - ##{customer.account_number}"
    end
  end
end
