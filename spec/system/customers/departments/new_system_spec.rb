require 'rails_helper'

describe 'New customer department' do 
  before(:each) do
    customer   = create(:customer)
    proprietor = create(:proprietor)
    login_as(proprietor, scope: :user)
    visit customer_path(customer)
    click_link "#{customer.id}-settings"
    click_link 'New Department'
  end

  it 'with valid attributes' do 
    fill_in 'Name', with: 'test department'

    click_button 'Create Department'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Department'

    expect(page).to have_content("can't be blank")
  end
end