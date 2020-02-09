require 'rails_helper'

describe 'New L1 account category' do 
  before(:each) do 
    store_front = create(:store_front)
    accountant  = create(:accountant, store_front: store_front)
    login_as(accountant, scope: :user)
    visit accounting_module_level_one_account_categories_path
    click_link 'New L1 Account Category'
  end 

  it "with valid attributes" do 
    fill_in 'Title', with: 'Cash on Hand'
    fill_in 'Code', with: '121321'
    check 'Contra'
    choose 'AccountingModule::AccountCategories::LevelOneAccountCategories::Asset'
    click_button "Save Account Category"

    expect(page).to have_content("saved successfully")
  end 
end 