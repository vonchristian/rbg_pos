require 'rails_helper'

describe LineItem do
  describe 'associations' do
    it { is_expected.to belong_to(:store_front).optional }
    it { is_expected.to belong_to(:stock).optional }

    it { is_expected.to belong_to(:commercial_document).optional }
    it { is_expected.to belong_to(:cart).optional }
    it { is_expected.to belong_to(:order).optional }
    it { is_expected.to belong_to(:product).optional }
    it { is_expected.to belong_to(:registry).optional }
    it { is_expected.to belong_to(:referenced_line_item).optional }
    it { is_expected.to belong_to :unit_of_measurement }
  end
  describe 'delegations' do
    it { is_expected.to delegate_method(:unit_code).to(:unit_of_measurement).allow_nil }
    it { is_expected.to delegate_method(:conversion_multiplier).to(:unit_of_measurement).allow_nil }
    it { is_expected.to delegate_method(:name).to(:product) }
    it { is_expected.to delegate_method(:name).to(:product).with_prefix }
  end

  it '.entered_on(args)' do
    order       = create(:sales_order, date: Date.current)
    old_order   = create(:sales_order, date: Date.current.last_year)
    line_item_1 = create(:line_item, order: order)
    line_item_2 = create(:line_item, order: old_order)

    expect(described_class.entered_on(from_date: Date.current, to_date: Date.current)).to include(line_item_1)
    expect(described_class.entered_on(from_date: Date.current, to_date: Date.current)).to_not include(line_item_2)

    expect(described_class.entered_on(from_date: Date.current.last_year, to_date: Date.current.last_year)).to include(line_item_2)
    expect(described_class.entered_on(from_date: Date.current.last_year, to_date: Date.current.last_year)).to_not include(line_item_1)
  end

  it '.for_store_front(store_front)' do
    store_front_1 = create(:store_front)
    store_front_2 = create(:store_front)
    order_1       = create(:sales_order, store_front: store_front_1)
    order_2       = create(:sales_order, store_front: store_front_2)
    line_item_1   = create(:line_item, order: order_1)
    line_item_2   = create(:line_item, order: order_2)

    expect(described_class.for_store_front(store_front_1)).to include(line_item_1)
    expect(described_class.for_store_front(store_front_1)).to_not include(line_item_2)

  end

  it ".with_orders" do
    order       = create(:sales_order)
    line_item   = create(:sales_order_line_item, order: order)
    line_item_2 = create(:sales_order_line_item, order_id: nil)

    expect(described_class.with_orders).to include(line_item)
    expect(described_class.with_orders).to_not include(line_item_2)
  end

  it '.total_cost' do
    line_item_1 = create(:line_item, unit_cost: 10, quantity: 1)
    line_item_2 = create(:line_item, unit_cost: 20, quantity: 1)

    expect(described_class.total_cost).to eql 30
  end

  it '.total' do
    base_unit_of_measurement = create(:unit_of_measurement, conversion_quantity: 1, base_measurement: true)
    not_base_measurement     = create(:unit_of_measurement, conversion_quantity: 5, base_measurement: false)
    order                    = create(:sales_order)
    line_item_1 = create(:line_item, quantity: 10, order: order, unit_of_measurement: base_unit_of_measurement)
    line_item_2 = create(:line_item, quantity: 10, order: order, unit_of_measurement: not_base_measurement)


    expect(described_class.total).to eql 60
  end

  it '#unit_cost_and_quantity' do
    line_item = create(:line_item, unit_cost: 10, quantity: 1)

    expect(line_item.unit_cost_and_quantity).to eql 10
  end

  it '#converted_quantity' do
    base_unit_of_measurement = create(:unit_of_measurement, conversion_quantity: 1, base_measurement: true)
    not_base_measurement     = create(:unit_of_measurement, conversion_quantity: 5, base_measurement: false)
    line_item_1              = create(:line_item, quantity: 10, unit_of_measurement: base_unit_of_measurement)
    line_item_2              = create(:line_item, quantity: 10, unit_of_measurement: not_base_measurement)

    expect(line_item_1.converted_quantity).to eql 10
    expect(line_item_2.converted_quantity).to eql 50
  end

  it '#processed?' do
    order_1       = create(:sales_order)
    line_item_1   = create(:line_item, order: order_1)
    line_item_2   = create(:line_item, order: nil)

    expect(line_item_1.processed?).to eql true
    expect(line_item_2.processed?).to eql false

  end




end
