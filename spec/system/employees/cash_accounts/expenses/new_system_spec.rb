require 'rails_helper'

describe 'New cash account expense' do
  before(:each) do
    cash        = create(:asset, name: 'Cash on Hand')
    expense     = create(:expense, name: 'Transportation')
    sales_clerk = create(:sales_clerk, cash_on_hand_account: cash)
    login_as(sales_clerk, scope: :user)
    visit cash_account_path(cash)
    click_link 'New Expense'
  end
  it 'with valid attributes' do
    fill_in 'Amount', with: 1_000
    select 'Transportation'
    fill_in 'Reference number', with: '232'
    fill_in 'Description',      with: 'expense 10/12/19'
    fill_in 'Date',             with: Date.current

    click_button 'Proceed'

    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')
    save_and_open_page

  end

end
