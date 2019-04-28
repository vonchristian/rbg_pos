module Employees
  class BillCount
    include ActiveModel::Model
    attr_accessor :bill_count, :bill_amount, :bill_id, :bill_subtotal, :bill_total
  end
end
