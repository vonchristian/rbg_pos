require 'rails_helper'

feature "Search product" do
  before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    product = create(:product, name: "Lotus")
    visit store_index_url
  end
  scenario " returns searched product results" do
    fill_in "store-search-form", with: 'Lotus'
    find(:css, 'i.icon-magnifier').click
    # expect(page).to have_content "Lotus"
    save_and_open_page
    expect(page).to have_current_path(store_index_path)
  end
end

