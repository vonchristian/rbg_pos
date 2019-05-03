module WorkOrders
  class ServiceChargeCancellation
    attr_reader :service_charge, :work_order
    def initialize(args)
      @service_charge = args.fetch(:service_charge)
      @work_order     = args.fetch(:work_order)
    end
    def cancel!
      delete_entry
      delete_service_charge
    end
    def delete_entry
      entries = AccountingModule::Amount.where(commercial_document: service_charge).pluck(:entry_id)
      AccountingModule::Entry.where(id: entries).destroy_all
    end

    def delete_service_charge
      work_order.work_order_service_charges.where(service_charge: service_charge).destroy_all
    end
  end
end
