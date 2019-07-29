require 'rails_helper'

describe 'New supplier voucher' do
  before(:each) do
    business   = create(:business)
    asset      = create(:asset, name: 'Accounts Payable')
    cash       = create(:asset, name: 'Cash')
    business.accounts << asset
    business.accounts << cash
    supplier   = create(:supplier)
    proprietor = create(:proprietor, business: business)
    login_as(proprietor, scope: :user)
    visit supplier_vouchers_path(supplier)
    click_link 'New Voucher'
  end

  it 'with valid attributes' do
    select 'Accounts Payable'
    fill_in 'Amount', with: 10_000
    select 'Debit'
    click_button 'Add'
 
    select 'Cash'
    fill_in 'Amount', with: 10_000
    select 'Credit'
    click_button 'Add'

    expect(page).to have_content('added successfully')

    fill_in 'Reference number', with: '1000'
    fill_in 'Date',             with: Date.current
    fill_in 'Description',      with: 'delivered stocks'

    click_button 'Create Voucher'

    expect(page).to have_content('created successfully.')
    save_and_open_page
    click_button 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')
  end
end
