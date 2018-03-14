class WorkOrderServiceCharge < ApplicationRecord
  has_many :amounts, class_name: "AccountingModule::Amount", as: :commercial_document
  belongs_to :service_charge
  belongs_to :work_order
  belongs_to :user
  delegate :description, :amount, to: :service_charge, allow_nil: true
end
