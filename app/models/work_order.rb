class WorkOrder < ApplicationRecord
  belongs_to :product_unit
  belongs_to :customer, optional: true
  belongs_to :technician, class_name: "User", foreign_key: 'technician_id', optional: true
  has_many :work_order_updates, as: :updateable, class_name: "Update"
  has_many :work_order_service_charges 
  has_many :service_charges, through: :work_order_service_charges
  has_many :spare_parts, class_name: "LineItem", foreign_key: 'work_order_id'
  enum status: [:received, :work_in_progress, :done]
  accepts_nested_attributes_for :product_unit
  def total_spare_parts_cost
    spare_parts.total_cost
  end
end
