require 'rails_helper'

describe 'Spare part cancellation' do
  before(:each) do  
    technician = create(:technician)
    proprietor = create(:proprietor, store_front: technician.store_front)
    @work_order = create(:work_order, store_front: technician.store_front)
    @stock       = create(:stock)
    purchase_order = create(:purchase_order)
    create(:purchase_order_line_item, order: purchase_order, stock: @stock, quantity: 10)
    sales_order  = create(:sales_order, commercial_document: @work_order)
    @sales_order_line_item = create(:sales_order_line_item, order: sales_order, stock: @stock)
    
    entry = build(:entry, commercial_document: sales_order)
    entry.debit_amounts.build(amount: sales_order.total_cost, account: @work_order.receivable_account)
    entry.credit_amounts.build(amount: sales_order.total_cost, account: @work_order.sales_revenue_account)
    entry.save!
    login_as(proprietor, scope: :user)

    visit computer_repair_section_work_order_path(@work_order)
  end 

  it "valid", js: true do 
    expect(@stock.balance).to eql 9
    expect(@work_order.receivable_account.balance).to eql 100
   
    click_link "#{@sales_order_line_item.id}-cancel-line-item"
    page.driver.browser.switch_to.alert.accept
    visit computer_repair_section_work_order_path(@work_order)
    expect(@work_order.receivable_account.balance).to eql 0
    expect(@stock.balance).to eql 10

 
  end 
end 