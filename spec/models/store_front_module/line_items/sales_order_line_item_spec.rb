require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe SalesOrderLineItem do
      describe 'associations' do
        it { is_expected.to belong_to(:sales_order).optional }
      end
    end
  end
end
