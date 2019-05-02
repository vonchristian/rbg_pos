class LedgerAccount < ApplicationRecord
  belongs_to :ledgerable, polymorphic: true
  belongs_to :account, class_name: 'AccountingModule::Account'
end
