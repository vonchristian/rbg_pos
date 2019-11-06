module StoreFronts
  module Orders
    class PurchaseOrder < ApplicationRecord
      belongs_to :supplier, polymorphic: true
      belongs_to :voucher
      belongs_to :employee, class_name: 'User'
      belongs_to :store_front
      belongs_to :receivable_account, class_name: 'AccountingModule::Account'

      validates :date, :account_number, presence: true
      validates :account_number, uniqueness: true
    end
  end
end
