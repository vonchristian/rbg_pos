require 'rails_helper'

describe 'New Customer' do 
  before(:each) do
    proprietor = create(:proprietor)
    login_as(proprietor, scope: :user)
    visit customers_path 
    click_link 'New Customer'
  end

  it 'with valid attributes', js: true do 
    fill_in 'First name', with: 'Juan'
    fill_in 'Last name', with: 'Cruz'
    fill_in 'Contact number', with: 'test number'
    fill_in 'Address', with: 'test address'

    click_button 'Save Customer'

    expect(page).to have_content('saved successfully')

  end

  it 'with invalid attributes' do
    click_button 'Save Customer'

    expect(page).to have_content("can't be blank")
  end
end