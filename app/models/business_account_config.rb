class BusinessAccountConfig < ApplicationRecord
  belongs_to :business
  belongs_to :service_receivable_category
  belongs_to :service_revenue_category
  belongs_to :sales_receivable_category
  belongs_to :sales_revenue_category
end
