class ServiceCharge < ApplicationRecord
  enum charge_type: [:regular, :additional]
end
