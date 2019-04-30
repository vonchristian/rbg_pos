FactoryBot.define do
  factory :work_order do
    association :work_order_category
    association :receivable_account, factory: :asset
    association :customer
    association :product_unit
    association :store_front

    physical_condition { "Physical condition" }
    reported_problem { "Reported problem" }
    date_received { Date.current }


  end
end
