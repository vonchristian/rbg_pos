class WorkOrder < ApplicationRecord
  belongs_to :product_unit
  belongs_to :customer, optional: true
  has_many :technician_work_orders, dependent: :destroy
  has_many :technicians, through: :technician_work_orders
  has_many :work_order_updates, as: :updateable, class_name: "Update", dependent: :destroy
  has_many :work_order_service_charges, dependent: :destroy
  has_many :service_charges, through: :work_order_service_charges
  has_many :spare_parts, class_name: "LineItem", foreign_key: 'work_order_id', dependent: :destroy
  enum status: [:received, :work_in_progress, :done, :released]
  accepts_nested_attributes_for :product_unit
  delegate :description, :model_number, :serial_number, to: :product_unit, allow_nil: true
  delegate :full_name, :address, :contact_number, to: :customer, allow_nil: true, prefix: true

  
  def total_spare_parts_cost
    spare_parts.total_cost
  end
  def total_service_charges_cost
    service_charges.sum(&:amount)
  end
  def total_charges_cost
    total_service_charges_cost + total_spare_parts_cost
  end
  def add_technician(technician)
    self.technician_work_orders.find_or_create_by(technician: technician)
  end
  def elapsed_time
    (self.created_at - Time.zone.now) /86400
  end
  def self.generate_number_for(work_order)
    if self.last.present? && self.last.service_number.present?
      work_order.service_number = "#{self.last.service_number.succ.rjust(12, '0')}"
    else 
     work_order.service_number =  "#{1.to_s.rjust(12, '0')}"
    end
  end
end
