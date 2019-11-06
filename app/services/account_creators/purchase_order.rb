module AccountCreators
  class PurchaseOrder
    attr_reader :purchase_order, :business

    def initialize(purchase_order:)
      @purchase_order = purchase_order
      @business       = @purchase_order.store_front.business
    end

    def create_accounts!
      create_payable_account
    end

    private

    def create_payable_account
      if purchase_order.payable_account.blank?
        account = AccountingModule::Liability.create!(
        business:     business,
        name:         payable_account_name,
        account_code: SecureRandom.uuid)
        purchase_order.update(payable_account: account)
      end
    end

    def payable_account_name
      "Accounts Payable Purchase Orders - #{purchase_order.supplier_name} ##{purchase_order.account_number}"
    end
  end
end
