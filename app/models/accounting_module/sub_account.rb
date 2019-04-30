module AccountingModule
  class SubAccount < ApplicationRecord
    belongs_to :main_account, class_name: 'AccountingModule::Account'
    belongs_to :sub_account,  class_name: 'AccountingModule::Account'
  end
end
