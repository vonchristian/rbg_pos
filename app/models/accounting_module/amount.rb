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

    def self.for_account(args={})
      where(account_id: args[:account_id])
    end

    def self.total
      sum(&:amount)
    end

    def self.entered_on(options={})
      if options[:from_date] && options[:to_date]
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        joins(:entry).where('entries.entry_date' => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end
  end
end
