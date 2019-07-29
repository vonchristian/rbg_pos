require 'rails_helper'

describe 'Product stock index' do
  it '#index' do
    product       = create(:product)
    store_front_1 = create(:store_front)
    store_front_2 = create(:store_front)
    stock_1       = create(:stock, store_front: store_front_1, product: product, barcode: '123')
    stock_2       = create(:stock, store_front: store_front_2, product: product, barcode: '456')
    order_1       = create(:purchase_order)
    order_2       = create(:purchase_order)
    purchase_1    = create(:purchase_order_line_item, stock: stock_1, quantity: 10, order: order_1)
    purchase_2    = create(:purchase_order_line_item, stock: stock_2, quantity: 10, order: order_2)
    user          = create(:proprietor, store_front: store_front_1)

    login_as(user, scope: :user)
    visit product_path(product)
    click_link "#{product.id}-stocks"

    expect(page).to have_content('123')
    expect(page).to_not have_content('456')
    save_and_open_page
  end
end
