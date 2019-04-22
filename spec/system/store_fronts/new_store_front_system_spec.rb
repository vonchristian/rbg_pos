require 'rails_helper'

describe 'New store front' do
  before(:each) do
    business = create(:business)
    user = create(:user, role: 'proprietor', business: business)
    merchandise_inventory_account = create(:asset, name: 'Merchandise Inventory')
    sales_account                 = create(:revenue, name: 'Sales')
    sales_discount_account        = create(:revenue, name: 'Sales Discounts')
    sales_return_account        = create(:revenue, name: 'Sales Returns')

    cost_of_goods_sold_account    = create(:expense, name: 'Cost of Goods Sold')
    receivable_account            = create(:asset, name: 'Receivables')
    internal_use_account          = create(:expense, name: 'Internal Uses')
    purchase_return_account       = create(:expense, name: 'Purchase Returns')
    spoilage_account              = create(:expense, name: 'Spoilages')
    service_revenue_account       = create(:revenue, name: 'Services')
    login_as(user, scope: :user)
    visit settings_path
    click_link 'New Store Front'
  end

  it 'with valid attributes' do
    fill_in 'Name', with: 'Store front 1'
    fill_in 'Address', with: 'Test address'
    select "Merchandise Inventory", from: "store_front_merchandise_inventory_account_id", match: :first
    select "Sales",                 from: "store_front_sales_account_id", match: :first
    select "Sales Discounts",       from: "store_front_sales_discount_account_id", match: :first
    select "Sales Returns",         from: "store_front_sales_return_account_id", match: :first
    select "Cost of Goods Sold",    from: "store_front_cost_of_goods_sold_account_id", match: :first
    select "Receivables",           from: "store_front_receivable_account_id", match: :first
    select "Internal Uses",         from: "store_front_internal_use_account_id", match: :first
    select "Spoilages",             from: "store_front_spoilage_account_id", match: :first
    select "Purchase Returns",      from: "store_front_purchase_return_account_id", match: :first
    select "Services",              from: "store_front_service_revenue_account_id", match: :first

    click_button 'Create Store Front'
    save_and_open_page
    expect(page).to have_content('created successfully')
    save_and_open_page

  end
end
