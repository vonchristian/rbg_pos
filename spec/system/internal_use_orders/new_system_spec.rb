require 'rails_helper'

describe 'New internal use order' do

  before(:each) do
    product                  = create(:product, name: 'Test Product')
    uom                      = create(:unit_of_measurement, product: product, base_measurement: true, conversion_quantity: 1)
    store_front              = create(:store_front, name: 'Lagawe')
    cart                     = create(:cart)
    stock                    = create(:stock, product: product, store_front: store_front, barcode: '11111111', unit_of_measurement: uom)
    supplier                 = create(:supplier)
    entry                    = create(:entry_with_credit_and_debit)
    voucher                  = create(:voucher, entry: entry, payee: supplier, reference_number: 'V001')
    purchase_order           = create(:purchase_order, supplier: supplier, voucher: voucher)
    purchase_order_line_item = create(:purchase_order_line_item, quantity: 10, stock: stock, product: product, unit_cost: 1, total_cost: 10, purchase_order: purchase_order)
    cash                     = create(:asset)
    sales_clerk              = create(:sales_clerk, first_name: 'Juan', last_name: 'Cruz', store_front: store_front, cash_on_hand_account: cash)
    sales_clerk.cash_accounts << cash
    login_as(sales_clerk, scope: :user)
    visit store_front_module_internal_use_orders_path
    click_link 'New Internal Use Order'
  end

  it 'with searched stock' do
    fill_in 'internal-use-search-form', with: '11111111'
    click_button 'internal-use-search-btn'

    fill_in 'line_item_quantity',   with: 1

    click_button "Add to Cart"

    expect(page).to have_content('added to cart')


    select 'Juan Cruz - Lagawe'
    fill_in 'internal-use-order-date', with: Date.current

    fill_in 'Description', with: '120DFG'

    click_button 'Save Internal Use Order'

    expect(page).to have_content('saved successfully')

  end

  it 'with searched product' do
    fill_in 'internal-use-search-form', with: 'Test Product'
    click_button 'internal-use-search-btn'

    fill_in 'line_item_quantity',   with: 1

    click_button "Add to Cart"

    expect(page).to have_content('added to cart')

    fill_in 'internal-use-order-date', with: Date.current
    select 'Juan Cruz'
    fill_in 'Description', with: '120DFG'

    click_button 'Save Internal Use Order'


    expect(page).to have_content('saved successfully')

  end
end
