module CashCounts
  class BillCount < ApplicationRecord
    belongs_to :bill
  end
end 
