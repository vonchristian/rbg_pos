module CashCounts
  class CashCount < ApplicationRecord
    belongs_to :employee
  end
end 
