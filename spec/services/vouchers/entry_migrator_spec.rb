require 'rails_helper'

module Vouchers
  describe EntryMigrator do
    it '#migrate_entries' do
      entry = create(:entry_with_credit_and_debit)
      voucher = create(:voucher, entry: entry, entry_id: nil)

      expect(voucher.entry_id).to eql nil

      described_class.new(voucher: voucher).migrate_entries

      expect(voucher.entry_id).to eql entry.id
    end
  end
end
