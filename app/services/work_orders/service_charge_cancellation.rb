module WorkOrders
  class ServiceChargeCancellation
    attr_reader :service_charge
    def initialize(args)
      @service_charge = args.fetch(:service_charge)
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
      service_charge.destroy
    end
  end
end
