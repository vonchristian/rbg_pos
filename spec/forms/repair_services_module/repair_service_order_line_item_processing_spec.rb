require 'rails_helper'

module RepairServicesModule 
  describe RepairServiceOrderLineItemProcessing, type: :model do 
    describe "#attributes" do 
      it { is_expected.to respond_to(:unit_of_measurement_id) }
      it { is_expected.to respond_to(:quantity) }
      it { is_expected.to respond_to(:cart_id) }
      it { is_expected.to respond_to(:product_id) }
      it { is_expected.to respond_to(:unit_cost) }
      it { is_expected.to respond_to(:bar_code) }
      it { is_expected.to respond_to(:stock_id) }
      it { is_expected.to respond_to(:work_order_id) }
      it { is_expected.to respond_to(:employee_id) }
    end 

    describe "validations" do 
      before(:each) do 
        @employee = create(:sales_clerk)
        @stock    = create(:stock, store_front: @employee.store_front)
        @cart     = create(:cart)
        purchase  = create(:purchase_order_line_item, quantity: 10, stock: @stock)
      end 

      it { expect(described_class.new(employee_id: @employee.id, stock_id: @stock.id, cart_id: @cart.id)).to validate_presence_of :quantity }
      it { expect(described_class.new(employee_id: @employee.id, stock_id: @stock.id, cart_id: @cart.id)).to validate_numericality_of(:quantity).is_greater_than(0.1) }
      it "quantity_is_less_than_or_equal_to_available_quantity?" do 
        expect(described_class.new(
          employee_id: @employee.id,
          stock_id:    @stock.id, 
          cart_id:     @cart.id, 
          quantity:    10,
          unit_cost:   50).valid?).to eq true 
      end
    end 

    it "#process!" do 
      employee = create(:sales_clerk)
      stock    = create(:stock, store_front: employee.store_front)
      cart     = create(:cart)
      purchase = create(:purchase_order_line_item, quantity: 10, stock: stock)

      described_class.new(
        employee_id: employee.id,
        stock_id:    stock.id, 
        cart_id:     cart.id, 
        quantity:    10,
        unit_cost:   50).process!
    
       expect(cart.sales_order_line_items.count).to eql 1
      end 
  end 
end 