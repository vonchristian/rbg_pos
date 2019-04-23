require 'rails_helper'

describe 'New account' do
  before(:each) do
    business     = create(:business)
    cash_in_bank = create(:asset, name: 'Cash in Bank', business: business)
    cash_on_hand = create(:asset, name: 'Cash on Hand', business: business)
    store_front  = create(:store_front, business: business)
    user         = create(:user, business: business)
    store_front.accounts << cash_on_hand
    login_as(user, scope: :user)
    visit store_front_module_store_front_accounts_path(store_front)
    click_link 'Add Account'
  end

  it 'with valid attributes' do
    select 'Cash in Bank'

    click_button 'Add Account'

    expect(page).to have_content('added successfully')
  end

  it 'invalid duplicated account' do
    select 'Cash on Hand'

    click_button 'Add Account'

    expect(page).to have_content("already been taken")
  end

end
