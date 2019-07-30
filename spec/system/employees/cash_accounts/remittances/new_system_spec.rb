require 'rails_helper'

describe 'New employee remittance' do
  before(:each) do
    cash        = create(:asset, name: 'Cash on Hand')
    cash_2      = create(:asset, name: 'Cash in Bank')
    proprietor  = create(:proprietor, cash_on_hand_account: cash_2)
    sales_clerk = create(:sales_clerk, cash_on_hand_account: cash)
    login_as(sales_clerk, scope: :user)
    visit employee_path(sales_clerk)
    click_link 'New Cash Transfer'
  end
  it 'with valid attributes' do
    save_and_open_page
    fill_in 'Amount', with: 1_000
    select 'Cash in Bank'
    fill_in 'Reference number', with: '232'
    fill_in 'Description', with: 'Cash transfer 10/12/19'
    fill_in 'Date', with: Date.current

    click_button 'Proceed'

    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')
  end

end
