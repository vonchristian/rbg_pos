module AccountCreators
  class WorkOrder
    attr_reader :work_order, :business
    def initialize(args={})
      @work_order = args.fetch(:work_order)
      @business   = @work_order.business
    end
    def create_account!
      account = AccountingModule::Asset.create!(
        business:     business,
        name:         account_name,
        account_code: SecureRandom.uuid)
      work_order.update(receivable_account: account)
    end

    def account_name
      "Accounts Receivable Work Orders - #{work_order.customer_name} #{work_order.service_number}"
    end
  end
end
