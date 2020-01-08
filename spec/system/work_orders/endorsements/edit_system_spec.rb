require 'rails_helper'
include ChosenSelect

describe 'Edit work order endorsement' do 
  before(:each) do 
    technician   = create(:technician)
    work_order   = create(:work_order, technician: technician, store_front: technician.store_front)
    technician_2 = create(:technician, store_front: technician.store_front, first_name: 'Juan', last_name: 'Cruz')

    login_as(technician, scope: :user)
    visit computer_repair_section_work_order_path(work_order)
    click_link 'Endorse'
  end 

  it 'with valid attributes', js: true do 
    select_from_chosen 'Juan Cruz', from: 'Technician'
    
    click_button 'Endorse Work Order'
    expect(page).to have_content('saved successfully')
  end 
end 