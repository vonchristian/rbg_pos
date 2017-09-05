class ProductUnitServiceCharge < ApplicationRecord
  belongs_to :product_unit
  belongs_to :service_charge
end
