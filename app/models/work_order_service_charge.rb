class WorkOrderServiceCharge < ApplicationRecord
  belongs_to :service_charge
  belongs_to :work_order
end
