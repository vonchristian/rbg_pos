require 'rails_helper'

describe 'New cash sales order' do
  before(:each) do
    customer    = create(:customer)
    product     = create(:product)
    store_front = create(:store_front)
    cart        = create(:cart)
    stock                    = create(:stock, product: product, store_front: store_front)
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
    click_link "sales-#{customer.id}"
    click_link 'New Cash Sale'
  end
  it 'with valid attributes' do
    fill_in 'Quantity',   with: 1
    fill_in 'Unit cost',  with: 100
    fill_in 'Total cost', with: 100
    fill_in 'Bar code',   with: '11111111'

    click_button "Add"
    save_and_open_page
    expect(page).to have_content('added successfully')
  end
end
