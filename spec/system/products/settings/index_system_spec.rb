require 'rails_helper'

describe 'Product settings index' do 
  before(:each) do 
    proprietor = create(:proprietor)
    product    = create(:product, name: 'Test Product', business: proprietor.business)
    login_as(proprietor, scope: :user)
    visit products_path 
    click_link 'Test Product'
    click_link "#{product.id}-settings"
  end 

  it 'is valid' do 
    expect(page).to have_content("Product Settings")
  end 
end 