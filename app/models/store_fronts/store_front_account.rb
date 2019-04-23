module StoreFronts
  class StoreFrontAccount < ApplicationRecord
    belongs_to :store_front
    belongs_to :account, class_name: 'AccountingModule::Account'

    validates :account_id, uniqueness: { scope: :store_front_id }
  end
end
