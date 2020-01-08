FactoryBot.define do
  factory :work_order do
    association :technician, factory: :technician
    association :work_order_category
    association :receivable_account, factory: :asset
    association :service_revenue_account, factory: :revenue
    association :sales_revenue_account, factory: :revenue 
    association :sales_discount_account, factory: :contra_revenue
    association :customer
    association :product_unit
    association :store_front

    physical_condition { "Physical condition" }
    reported_problem { "Reported problem" }
    date_received { Date.current }
    service_number { '32132' }


  end
end
