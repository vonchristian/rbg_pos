class Voucher < ApplicationRecord
  belongs_to :payee,               polymorphic: true
  belongs_to :commercial_document, polymorphic: true, optional: true
  belongs_to :preparer,            class_name: "User", optional: true
  has_one :entry,                  class_name: "AccountingModule::Entry",
                                   as: :commercial_document
  belongs_to :accounting_entry,    class_name: 'AccountingModule::Entry', foreign_key: 'entry_id', optional: true
  has_many :voucher_amounts,       class_name: "Vouchers::VoucherAmount", dependent: :destroy

  delegate :name, to: :preparer, prefix: true, allow_nil: true

  delegate :name, to: :disburser, prefix: true, allow_nil: true
  delegate :name, to: :payee, prefix: true
  delegate :total, to: :entry, allow_nil: true

  validates :account_number, presence: true, uniqueness: true

  def self.unused
    where(entry_id: nil)
  end
  def self.disbursed
    where.not(entry_id: nil)
  end

  def payable_amount
    voucher_amounts.debit.sum(&:amount)
  end

  def disbursed?
    accounting_entry.present?
  end

  def disburser
    entry.recorder
  end

  def unused?
    !disbursed?
  end

  def disbursement_status
    if !disbursed?
      "Pending"
    else
      "Disbursed"
    end
  end

end
