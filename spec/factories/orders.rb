FactoryBot.define do
  factory :order do
    date "2017-07-18 17:46:00"
    account_number { SecureRandom.uuid }
    association :commercial_document, factory: :customer
    association :employee, factory: :user
    association :store_front



    factory :stock_transfer_order, class: StoreFrontModule::Orders::StockTransferOrder do
      association :destination_store_front, factory: :store_front
    end

    factory :sales_order, class: StoreFrontModule::Orders::SalesOrder do |order_cd|
      order_cd.association :commercial_document, factory: :customer
      order_cd.after(:build) do |t|
        t.sales_order_line_items << create(:sales_order_line_item)
      end
    end



    factory :sales_return_order, class: StoreFrontModule::Orders::SalesReturnOrder do |order_cd|
      order_cd.association :commercial_document, factory: :customer
      order_cd.after(:build) do |t|
        t.sales_return_order_line_items << create(:sales_return_order_line_item)
      end
    end

    factory :internal_use_order, class: StoreFrontModule::Orders::InternalUseOrder do |order_cd|
      order_cd.association :commercial_document, factory: :customer
      order_cd.after(:build) do |t|
        t.internal_use_order_line_items << create(:internal_use_order_line_item)
      end
    end

    factory :purchase_order, class: StoreFrontModule::Orders::PurchaseOrder do |order_cd|
      order_cd.association :commercial_document, factory: :supplier
      order_cd.after(:build) do |t|
        t.purchase_order_line_items << create(:purchase_order_line_item)
      end
    end

    factory :purchase_return_order, class: StoreFrontModule::Orders::PurchaseReturnOrder do |order_cd|
      order_cd.association :commercial_document, factory: :supplier
      order_cd.after(:build) do |t|
        t.purchase_return_order_line_items << create(:purchase_return_order_line_item)
      end
    end

    factory :spoilage_order, class: StoreFrontModule::Orders::SpoilageOrder do |order_cd|
      order_cd.association :commercial_document, factory: :user
      order_cd.after(:build) do |t|
        t.spoilage_order_line_items << create(:spoilage_order_line_item)
      end
    end

  end
end
