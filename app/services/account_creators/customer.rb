module AccountCreators
  class Customer
    attr_reader :customer, :business
    def initialize(args={})
      @customer = args.fetch(:customer)
      @business   = @customer.business
    end
    def create_account!
      account = AccountingModule::Asset.create!(
        business:     business,
        name:         account_name,
        account_code: SecureRandom.uuid)
      customer.update(receivable_account: account)
    end

    def account_name
      "Accounts Receivable - #{customer.full_name} - #{customer.account_number}"
    end
  end
end
