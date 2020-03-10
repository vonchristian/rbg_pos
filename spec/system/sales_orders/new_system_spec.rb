require 'rails_helper'
include ChosenSelect
describe 'New cash sales order' do


  before(:each) do
    product     = create(:product, name: 'Test Product')
    uom         = create(:unit_of_measurement, product: product, base_measurement: true, conversion_quantity: 1)
    store_front = create(:store_front)
    cart        = create(:cart)
    stock                    = create(:stock, product: product, store_front: store_front, barcode: '11111111', unit_of_measurement: uom)
    supplier                 = create(:supplier)
    entry                    = create(:entry_with_credit_and_debit)
    voucher                  = create(:voucher, entry: entry, payee: supplier, reference_number: 'V001')
    purchase_order           = create(:purchase_order, supplier: supplier, voucher: voucher)
    purchase_order_line_item = create(:purchase_order_line_item, quantity: 10, stock: stock, purchase_order: purchase_order, unit_cost: 100)
    cash                     = create(:asset)
    sales_clerk              = create(:sales_clerk, store_front: store_front, cash_on_hand_account: cash)
    @customer                = create(:customer, business: sales_clerk.business)
    sales_clerk.cash_accounts << cash
    login_as(sales_clerk, scope: :user)
    visit store_index_path
  end
  it 'with valid attributes', js: true do
    fill_in 'stock-search-form', with: '11111111'
    click_button 'stock-search-btn'
    fill_in 'line_item_quantity',   with: 1
    fill_in 'line_item_selling_price',  with: 100

    click_button "Add to Cart"

    expect(page).to have_content('added to cart')

    fill_in "customer-search-form", with: @customer.full_name
    click_button "customer-search-btn"
    click_link "#{@customer.id}-select-customer"
    fill_in 'sale-order-date', with: Date.current.strftime('%B %e, %Y')

    fill_in 'Cash tendered',    with: 100
    fill_in 'Discount',         with: 0
    fill_in 'Reference number', with: '120DFG'

    click_button 'Save Order'


    expect(page).to have_content('saved successfully')

  end
  it 'with searched product', js: true do
    fill_in 'stock-search-form', with: 'Test Product'
    click_button 'stock-search-btn'
    fill_in 'line_item_quantity',   with: 1
    fill_in 'line_item_selling_price',  with: 100

    click_button "Add to Cart"

    expect(page).to have_content('added to cart')

    fill_in "customer-search-form", with: @customer.full_name
    click_button "customer-search-btn"
    click_link "#{@customer.id}-select-customer"
    fill_in 'sale-order-date', with: Date.current.strftime('%B %e, %Y')

    fill_in 'Cash tendered',    with: 100
    fill_in 'Discount',         with: 0
    fill_in 'Reference number', with: '120DFG'

    click_button 'Save Order'


    expect(page).to have_content('saved successfully')

  end
end
