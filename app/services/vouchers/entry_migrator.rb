module Vouchers
  class EntryMigrator
    attr_reader :voucher, :entry
    def initialize(voucher:)
      @voucher = voucher
      @entry   = voucher.entry
    end

    def migrate_entries
      if entry.present?
        voucher.update_attributes!(entry_id: entry.id)
      end
    end
  end
end
