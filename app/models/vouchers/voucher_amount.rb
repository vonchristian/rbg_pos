module Vouchers
  class VoucherAmount < ApplicationRecord
    enum amount_type: [:debit, :credit]
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :voucher, optional: true
    belongs_to :commercial_document, polymorphic: true

    delegate :name, to: :account, prefix: true
  end
end
