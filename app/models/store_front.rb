class StoreFront < ApplicationRecord
  belongs_to :business
  belongs_to :merchandise_inventory_account, class_name: "AccountingModule::Account"
end
