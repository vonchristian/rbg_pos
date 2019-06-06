class Department < ApplicationRecord
  belongs_to :customer
  validates :name, presence: true, uniqueness: { scope: :customer_id }
  def customer_name_and_department
    "#{customer.name} - #{name}"
  end
end
