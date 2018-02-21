module Vouchers
  class VoucherAmount < ApplicationRecord
    belongs_to :voucher
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :commercial_document, polymorphic: true

    delegate :name, to: :account, prefix: true
  end
end
