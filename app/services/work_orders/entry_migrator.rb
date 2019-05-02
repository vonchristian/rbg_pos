module WorkOrders
  class EntryMigrator
    attr_reader :work_order

    def initialize(args)
      @work_order = args.fetch(:work_order)
    end

    def migrate_entries!
      migrate_receivable_account_entries
      migrate_sales_account_entries
    end

    def migrate_receivable_account_entries
      work_order.service_charges.each do |charge|
        StoreFront.receivable_accounts.each do |account|
          account.debit_amounts.where(commercial_document: charge).each do |amount|
            amount.update(account: work_order.receivable_account)
          end
        end
      end
    end
    
    def migrate_sales_account_entries
      StoreFront.sales_accounts.each do |account|
        account.credit_amounts.where(commercial_document: work_order).each do |amount|
          amount.update(account: work_order.sales_revenue_account)
        end
      end
    end
  end
end
