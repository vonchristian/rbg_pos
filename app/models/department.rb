class Department < ApplicationRecord
  belongs_to :customer
  validates :name, presence: true, uniqueness: { scope: :customer_id }
end
