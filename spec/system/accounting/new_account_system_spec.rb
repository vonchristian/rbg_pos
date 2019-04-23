require 'rails_helper'

describe 'New account' do
  before(:each) do
    user = create(:user, role: 'proprietor')
    login_as(user, scope: :user)
    visit accounting_index_path
    click_link 'New Account'
  end

  it 'with valid attributes' do
    fill_in 'Name', with: 'Test account'
    fill_in 'Account code', with: '1321321'
    select 'AccountingModule::Asset'

    click_button 'Create Account'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Account'

    expect(page).to have_content "can't be blank"
  end
end
