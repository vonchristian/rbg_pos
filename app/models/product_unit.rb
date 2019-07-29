class ProductUnit < ApplicationRecord
  has_many :repairs, class_name: "WorkOrder"
  include PgSearch::Model
  multisearchable :against => [:description, :model_number, :serial_number]
  has_many :accessories
  validates :description, presence: true
end
