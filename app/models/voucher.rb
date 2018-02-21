class Voucher < ApplicationRecord
  belongs_to :payee,         polymorphic: true
  belongs_to :commercial_document, polymorphic: true, optional: true
  belongs_to :preparer,      class_name: "User", optional: true
  has_one :entry,            class_name: "AccountingModule::Entry",
                             as: :commercial_document

  has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount"

  delegate :name, to: :preparer, prefix: true, allow_nil: true
  delegate :name, to: :payee, prefix: true
  def self.unused
    select{ |a| a.unused? }
  end
  def payable_amount
    voucher_amounts.debit.sum(&:amount)
  end
  def disbursed?
    entry.present?
  end
  def disburser
    entry.recorder
  end
  def unused?
    commercial_document.blank?
  end
  def disbursement_status
    if !disbursed?
      "Pending"
    else
      "Disbursed"
    end
  end
end
