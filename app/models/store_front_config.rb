class StoreFrontConfig < ApplicationRecord
  belongs_to :accounts_receivable_account
  belongs_to :store_front
end
