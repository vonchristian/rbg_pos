class JobOrder < ApplicationRecord
  belongs_to :unit
  belongs_to :customer
  accepts_nested_attributes_for :unit
end
