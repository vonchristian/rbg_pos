class ProductUnit < ApplicationRecord
  has_many :repairs, class_name: "WorkOrder"
  include PgSearch
  multisearchable :against => [:description, :model_number, :serial_number]
  has_many :accessories
end
