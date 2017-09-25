class WorkOrderServiceCharge < ApplicationRecord
  belongs_to :service_charge
  belongs_to :work_order
  belongs_to :user
  delegate :description, :amount, to: :service_charge, allow_nil: true
  def remove_entry
    entry = work_order.entries.work_order_service_charge.where(user_id: self.user_id).last
    if entry.present?
      entry.destroy
    end
  end
end
