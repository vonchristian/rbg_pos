class WorkOrderForm 
  include ActiveModel::Model 
  attr_accessor :description, :model_number, :serial_number, :physical_condition, :reported_problem
end 