require 'rails_helper'

describe OtherSalesLineItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:order).optional }
    it { is_expected.to belong_to(:cart).optional }
  end
  it '.total_cost' do
    other   = create(:other_sales_line_item, amount: 100)
    other_2 = create(:other_sales_line_item, amount: 50)

    expect(described_class.total_cost).to eql 150
  end 
end
