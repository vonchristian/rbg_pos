module WorkOrders
  class EntryMigrator
    attr_reader :work_order, :receivable_account, :store_front

    def initialize(args)
      @work_order = args.fetch(:work_order)
      @store_front = @work_order.store_front
      @receivable_account = @work_order.receivable_account
    end

    def migrate_service_charge_entries!
      work_order.service_charges.each do |charge|
        store_front.receivable_account.debit_amounts.where(commercial_document: charge).each do |amount|
          amount.update(account: receivable_account)
        end
      end
    end
  end
end
