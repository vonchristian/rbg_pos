require 'rails_helper'

describe 'Stocks index page' do
  before(:each) do
    product       = create(:product, name: 'Test Product')
    store_front_1 = create(:store_front)
    store_front_2 = create(:store_front)
    stock_1       = create(:stock, store_front: store_front_1, product: product, barcode: '123')
    stock_2       = create(:stock, store_front: store_front_2, product: product, barcode: '456')
    entry_1       = create(:entry_with_credit_and_debit)
    entry_2       = create(:entry_with_credit_and_debit)
    voucher_1     = create(:voucher, entry: entry_1)
    voucher_2     = create(:voucher, entry: entry_2)
    order_1       = create(:purchase_order, voucher: voucher_1, store_front: store_front_1)
    order_2       = create(:purchase_order, voucher: voucher_2, store_front: store_front_2)
    purchase_1    = create(:purchase_order_line_item, stock: stock_1, unit_cost: 100, total_cost: 1000, quantity: 10, order: order_1)
    purchase_2    = create(:purchase_order_line_item, stock: stock_2, unit_cost: 100, total_cost: 1000, quantity: 10, order: order_2)
    user          = create(:proprietor, store_front: store_front_1)
    login_as(user, scope: :user)
    visit inventories_path
  end
  it 'shows stock details' do
    expect(page).to have_content('Test Product')
    expect(page).to have_content('123')
    expect(page).to_not have_content('456')
    save_and_open_page
  end
end
