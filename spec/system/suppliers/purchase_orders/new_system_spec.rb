require 'rails_helper'

describe 'New purchase order' do
  before(:each) do
    product    = create(:product, name: 'Test Product')
    uom        = create(:unit_of_measurement, unit_code: 'pc', product: product)
    supplier   = create(:supplier)
    entry      = create(:entry_with_credit_and_debit)
    voucher    = create(:voucher, entry: entry, payee: supplier, reference_number: 'V001')
    proprietor = create(:proprietor)
    login_as(proprietor, scope: :user)
    visit supplier_purchase_orders_path(supplier)
    click_link 'New Purchase Order'
  end

  it 'with valid attributes' do
    click_link "Select"
    fill_in 'Quantity',      with: 1
    fill_in 'Unit cost',     with: 100
    fill_in 'Total cost',    with: 100
    fill_in 'Selling price', with: 150
    fill_in 'Barcode',       with: '313123'

    select 'pc'

    click_button 'Add'

    click_link "Select"
    fill_in 'Quantity',      with: 1
    fill_in 'Unit cost',     with: 100
    fill_in 'Total cost',    with: 100
    fill_in 'Selling price', with: 150

    fill_in 'Barcode',       with: '3131233'
    select 'pc'
    click_button 'Add'


    fill_in 'Date', with: Date.current
    select 'V001'
    click_button "Save Purchase"


    expect(page).to have_content('saved successfully')
  end
end
