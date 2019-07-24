require 'rails_helper'

describe Order do
  describe 'associations' do
    it { is_expected.to belong_to(:commercial_document).optional }
    it { is_expected.to belong_to(:store_front) }
    it { is_expected.to belong_to :employee }
    it { is_expected.to have_one :cash_payment }
    it { is_expected.to have_one :entry }
    it { is_expected.to belong_to(:voucher).optional }
    it { is_expected.to have_many :line_items }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:cash_tendered).to(:cash_payment).with_prefix }
    it { is_expected.to delegate_method(:full_name).to(:employee).with_prefix }
    it { is_expected.to delegate_method(:discount_amount).to(:cash_payment) }
  end

  it ".credit" do
    credit_order = create(:order, credit: true)
    cash_order = create(:order, credit: false)

    expect(described_class.credit).to include(credit_order)
    expect(described_class.credit).to_not include(cash_order)
  end

  it ".total_cost" do
    order_1 = create(:sales_order)
    5.times do
      order_1.sales_order_line_items << create(:sales_order_line_item, quantity: 1, unit_cost: 100, total_cost: 100)
    end

    order_2 = create(:sales_order)
    5.times do
      order_2.sales_order_line_items << create(:sales_order_line_item, quantity: 1, unit_cost: 100, total_cost: 100)
    end

    expect(described_class.total_cost).to eql 1_000
  end

  it ".ordered_on(args={})" do
    order = create(:sales_order, date: Date.today.last_month)
    order_2 = create(:sales_order, date: Date.today)

    expect(described_class.ordered_on(from_date: Date.today.last_month.beginning_of_month, to_date: Date.today.last_month.end_of_month)).to include(order)
    expect(described_class.ordered_on(from_date: Date.today.last_month.beginning_of_month, to_date: Date.today.last_month.end_of_month)).to_not include(order_2)

    expect(described_class.ordered_on(from_date: Date.today.beginning_of_month, to_date: Date.today.end_of_month)).to include(order_2)
    expect(described_class.ordered_on(from_date: Date.today.beginning_of_month, to_date: Date.today.end_of_month)).to_not include(order)
  end
end
