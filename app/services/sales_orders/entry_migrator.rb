module SalesOrders
  class EntryMigrator
    attr_reader :sales_order

    def initialize(args)
      @sales_order = args.fetch(:sales_order)
    end
    def migrate_entries!
      migrate_sales_account_entries
      migrate_receivable_account_entries
      migrate_sales_discount_account_entries
    end

    def migrate_receivable_account_entries
      StoreFront.receivable_accounts.each do |account|
        account.amounts.where(commercial_document: sales_order).each do |amount|
          amount.update(account: sales_order.receivable_account)
        end
      end
    end

    def migrate_sales_account_entries
      StoreFront.sales_accounts.each do |account|
        account.amounts.where(commercial_document: sales_order).each do |amount|
          amount.update(account: sales_order.sales_revenue_account)
        end
      end
    end

    def migrate_sales_discount_account_entries
      StoreFront.sales_discount_accounts.each do |account|
        account.amounts.where(commercial_document: sales_order).each do |amount|
          amount.update(account: sales_order.sales_discount_account)
        end
      end
    end
  end
end
