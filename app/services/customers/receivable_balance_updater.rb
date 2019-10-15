module Customers
  class ReceivableBalanceUpdater
    attr_reader :customer, :receivable_account

    def initialize(customer:)
      @customer = customer
      @receivable_account = @customer.receivable_account
    end

    def update_balance!
      customer.update!(receivable_balance: receivable_account.balance)
    end
  end
end
