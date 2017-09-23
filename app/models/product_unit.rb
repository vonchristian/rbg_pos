class ProductUnit < ApplicationRecord
  include PgSearch
  multisearchable :against => [:description, :model_number, :serial_number]
end
