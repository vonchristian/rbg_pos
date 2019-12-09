require 'rails_helper'
describe 'New work order spare parts' do
  before(:each) do
    work_order               = create(:work_order)
    supplier                 = create(:supplier, business_name: 'Test supplier')
    category                 = create(:work_order_category, title: 'Desktop')
    customer                 = create(:customer, first_name: 'Juan', last_name: 'Cruz')
    work_order               = create(:work_order, customer: customer, work_order_category: category)
    product                  = create(:product, name: 'Test Product')
    uom                      = create(:unit_of_measurement, product: product, base_measurement: true, conversion_quantity: 1)
    store_front              = create(:store_front)
    cart                     = create(:cart)
    stock                    = create(:stock, product: product, store_front: store_front, barcode: '11111111', unit_of_measurement: uom)
    supplier                 = create(:supplier)
    entry                    = create(:entry_with_credit_and_debit)
    voucher                  = create(:voucher, entry: entry, payee: supplier, reference_number: 'V001')
    purchase_order           = create(:purchase_order, supplier: supplier, voucher: voucher)
    purchase_order_line_item = create(:purchase_order_line_item, quantity: 10, stock: stock, product: product, unit_cost: 1, total_cost: 10, purchase_order: purchase_order)
    user = create(:user, role: 'technician', store_front: store_front)

    login_as(user, scope: :user)
    visit computer_repair_section_work_order_path(work_order)
    click_link 'Add Parts'
  end
  it 'with searched stock' do
    fill_in 'spare-part-search-form', with: '11111111'
    click_button 'Search'
    fill_in 'line_item_quantity',   with: 1
    fill_in 'line_item_selling_price',  with: 100

    click_button "Add to Cart"
    fill_in 'Date', with: Date.current

    click_button 'Save Order'

    expect(page).to have_content('saved successfully')
  end

  it 'with searched product' do
    fill_in 'spare-part-search-form', with: 'Test Product'
    click_button 'Search'
    fill_in 'line_item_quantity',   with: 1
    fill_in 'line_item_selling_price',  with: 100

    click_button "Add to Cart"
    fill_in 'Date', with: Date.current

    click_button 'Save Order'

    expect(page).to have_content('saved successfully')
    
  end
end
