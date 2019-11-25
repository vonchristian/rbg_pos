class ProductUnit < ApplicationRecord
  include PgSearch::Model
  multisearchable :against => [:description, :model_number, :serial_number]

  belongs_to :customer 
  has_many :accessories
  has_many :repairs, class_name: "WorkOrder"

  validates :description, presence: true
end
