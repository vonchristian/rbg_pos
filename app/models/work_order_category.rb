class WorkOrderCategory < ApplicationRecord
  has_many :work_orders
  validates :title, presence: true, uniqueness: true
end
