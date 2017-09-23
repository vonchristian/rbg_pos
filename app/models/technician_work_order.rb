class TechnicianWorkOrder < ApplicationRecord
  belongs_to :technician, class_name: "User", foreign_key: 'technician_id'
  belongs_to :work_order
end
