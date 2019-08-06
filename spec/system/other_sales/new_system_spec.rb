require 'rails_helper'

describe 'New other sales' do
  before(:each) do
    cash        = create(:asset)
    sales_clerk = create(:sales_clerk, cash_on_hand_account: cash)
    customer    = create(:customer, first_name: 'Juan', last_name: 'Cruz')
    login_as(sales_clerk, scope: :user)
    visit store_index_path
    click_link 'New Other Sale'
  end
  it 'with valid attributes' do
    fill_in 'Date', with: Date.current
    select 'Juan Cruz'
    fill_in 'Reference number', with: '3213'
    fill_in 'Description', with: 'test sale'
    fill_in 'Amount', with: 1_000

    click_button 'Save Other Sale'

    expect(page).to have_content('saved successfully')


  end
end
