module StoreFrontModule
  class CashPayment < ApplicationRecord
    belongs_to :cash_paymentable, polymorphic: true
  end
end
