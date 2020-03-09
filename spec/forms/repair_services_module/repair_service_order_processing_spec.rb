require 'rails_helper'

module RepairServicesModule
  describe RepairServiceOrderProcessing, type: :model do 
    describe "attributes" do 
      it { is_expected.to respond_to(:customer_id) }
      it { is_expected.to respond_to(:employee_id) }
      it { is_expected.to respond_to(:cart_id) }
      it { is_expected.to respond_to(:date) }
      it { is_expected.to respond_to(:work_order_id) }
      it { is_expected.to respond_to(:reference_number) }
    end 
    describe "validations" do 
      it { is_expected.to validate_presence_of :customer_id }
      it { is_expected.to validate_presence_of :date }
      it { is_expected.to validate_presence_of :reference_number }
      it { is_expected.to validate_presence_of :cart_id }
      it { is_expected.to validate_presence_of :employee_id }
      it { is_expected.to validate_presence_of :work_order_id }
    end 
    it "#process!" do 
      
      cart                  = create(:cart)
      sales_order_line_item = create(:sales_order_line_item, cart: cart)
      sales_clerk           = create(:sales_clerk)
      customer              = create(:customer)
      work_order            = create(:work_order, store_front: sales_clerk.store_front)
      
      described_class.new(
        date:             Date.current, 
        reference_number: 'test',
        cart_id:          cart.id,
        employee_id:      sales_clerk.id,
        work_order_id:    work_order.id,
        customer_id:      customer.id
      ).process!

      expect(sales_clerk.store_front.sales_orders.count).to eql 1
    end 
  end 
end 