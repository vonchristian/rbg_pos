require 'rails_helper'

describe 'New customer credit sales order' do
  let!(:customer)  { create(:customer) }

  before(:each) do
    product     = create(:product, name: 'Test Product')
    uom         = create(:unit_of_measurement, product: product, base_measurement: true, conversion_quantity: 1)
    store_front = create(:store_front)
    cart        = create(:cart)
    customer    = create(:customer, first_name: 'Juan', last_name: 'Cruz')
    stock                    = create(:stock, product: product, store_front: store_front, barcode: '11111111', unit_of_measurement: uom)
    supplier                 = create(:supplier)
    entry                    = create(:entry_with_credit_and_debit)
    voucher                  = create(:voucher, entry: entry, payee: supplier, reference_number: 'V001')
    purchase_order           = create(:purchase_order, supplier: supplier, voucher: voucher)
    purchase_order_line_item = create(:purchase_order_line_item, quantity: 10, stock: stock, purchase_order: purchase_order)
    cash                     = create(:asset)
    sales_clerk              = create(:sales_clerk, store_front: store_front, cash_on_hand_account: cash)
    sales_clerk.cash_accounts << cash
    login_as(sales_clerk, scope: :user)
    visit customer_path(customer)
    click_link "#{customer.id}-orders"
    click_link 'New Credit Sale'
  end
  it 'with searched stock' do
    fill_in 'stock-search-form', with: '11111111'
    click_button 'stock-search-btn'
    fill_in 'line_item_quantity',   with: 1
    fill_in 'line_item_selling_price',  with: 100

    click_button "Add to Cart"

    expect(page).to have_content('added to cart')
    save_and_open_page
    fill_in 'credit-sale-order-date', with: Date.current
    fill_in 'Charge Invoice No.', with: '120DFG'
    fill_in 'Purchase Order No.', with: '120DFG'


    click_button 'Save Credit Order'
    save_and_open_page

    expect(page).to have_content('saved successfully')
  end
end
