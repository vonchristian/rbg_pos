module Vouchers
  class DisbursementProcessing
    include ActiveModel::Model
    attr_accessor :date, :disburser_id, :amount, :description
  end
end
