module AccountingModule
  class SupplierPaymentForm
    include ActiveModel::Model
    attr_accessor :entry_date,
                  :reference_number,
                  :description,
                  :supplier_id,
                  :user_id,
                  :credit_account_id,
                  :amount
    validates :entry_date, :description,  presence: true
    validates :amount, presence: true, numericality: true
    def save
      ActiveRecord::Base.transaction do
        create_entry
      end
    end

    private
    def create_entry
      AccountingModule::Entry.create!(
        user_id: user_id,
        recorder_id: user_id,
        commercial_document: find_supplier,
        entry_date: entry_date,
        reference_number: reference_number,
        description: description,
        credit_amounts_attributes: [amount: amount, account_id: credit_account_id],
        debit_amounts_attributes: [amount: amount, account: debit_account])
    end
    def find_supplier
      Supplier.find_by_id(supplier_id)
    end
    def debit_account
      find_supplier.default_accounts_payable_account
    end
  end
end
