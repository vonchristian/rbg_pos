module AccountingModule
  class Amount < ApplicationRecord
    belongs_to :entry, :class_name => 'AccountingModule::Entry'
    belongs_to :account, :class_name => 'AccountingModule::Account'
    belongs_to :commercial_document, polymorphic: true, optional: true
    validates :type, :amount, :entry, :account, presence: true
    validates :amount, numericality: true

  end
end
