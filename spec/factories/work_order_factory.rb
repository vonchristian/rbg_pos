FactoryBot.define do
  factory :work_order do
    association :product_unit
    association :store_front
  
    physical_condition { "Physical condition" }
    reported_problem { "Reported problem" }
    date_received { Date.current }
    association :customer


  end
end
