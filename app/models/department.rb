class Department < ApplicationRecord
  belongs_to :customer
  has_many :sales_orders, class_name: 'StoreFrontModule::Orders::SalesOrder'
  validates :name, presence: true, uniqueness: { scope: :customer_id }

  def customer_name_and_department
    "#{customer.name} - #{name}"
  end
end
