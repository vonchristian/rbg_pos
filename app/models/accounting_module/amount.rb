module AccountingModule
  class Amount < ApplicationRecord
    belongs_to :entry, :class_name => 'AccountingModule::Entry'
    belongs_to :account, :class_name => 'AccountingModule::Account'

    validates :type, :amount, :entry, :account, presence: true
    validates :amount, numericality: true

    delegate :name, to: :account, prefix: true
    delegate :recorder, :entry_date, :description, to: :entry
    delegate :name, to: :recorder, prefix: true

    def self.for_account(args={})
      where(account_id: args[:account_id])
    end

    def self.total
      sum(&:amount)
    end
    def self.balance(args={})
      balance_finder(args).new(args.merge(amounts: self)).compute
    end

    def self.balance_for_new_record
      balance = BigDecimal('0')
      self.all.each do |amount_record|
        if amount_record.amount && !amount_record.marked_for_destruction?
          balance += amount_record.amount # unless amount_record.marked_for_destruction?
        end
      end
      return balance
    end

    def self.entered_on(options={})
      if options[:from_date] && options[:to_date]
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        joins(:entry).where('entries.entry_date' => (date_range.start_date..date_range.end_date))
      else
        self.all
      end
    end

    private
    def self.balance_finder(args={})
      if args.present?
        klass = args.compact.keys.sort.map{ |key| key.to_s.titleize }.join.gsub(" ", "")
      else
        klass = "DefaultBalanceFinder"
      end
      ("AccountingModule::BalanceFinders::" + klass).constantize
    end
  end
end
