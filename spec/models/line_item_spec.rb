require 'rails_helper'

describe LineItem do
  it ".with_orders" do
    order = create(:sales_order)
    line_item = create(:sales_order_line_item, order: order)
    line_item_2 = create(:sales_order_line_item, order_id: nil)

    expect(described_class.with_orders).to include(line_item)
    expect(described_class.with_orders).to_not include(line_item_2)
  end 
end
