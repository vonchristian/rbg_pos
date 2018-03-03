module AccountingModule
  class Amount < ApplicationRecord
    belongs_to :entry, :class_name => 'AccountingModule::Entry'
    belongs_to :account, :class_name => 'AccountingModule::Account'
    belongs_to :commercial_document, polymorphic: true, optional: true
    validates :type, :amount, :entry, :account, presence: true
    validates :amount, numericality: true

    delegate :name, to: :account, prefix: true
    delegate :recorder, :entry_date, :description, to: :entry
    delegate :name, to: :commercial_document, prefix: true, allow_nil: true
    delegate :name, to: :recorder, prefix: true, allow_nil: true
    def self.total
      sum(&:amount)
    end
  end
end
