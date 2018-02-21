class Voucher < ApplicationRecord
  belongs_to :payee,         polymorphic: true
  belongs_to :preparer,      class_name: "User", optional: true
  belongs_to :disburser,     class_name: "User", optional: true
  has_one :entry,            class_name: "AccountingModule::Entry",
                             as: :commercial_document
  has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount"

  delegate :name, to: :preparer, prefix: true, allow_nil: true
  delegate :name, to: :disburser, prefix: true, allow_nil: true

  def disbursed?
    entry.present?
  end
end
