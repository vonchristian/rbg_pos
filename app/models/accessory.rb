class Accessory < ApplicationRecord
  belongs_to :product_unit
  belongs_to :work_order
end
