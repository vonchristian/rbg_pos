require 'rails_helper'

describe WorkOrder do
  describe 'associations' do
    it { is_expected.to belong_to :product_unit }
    it { is_expected.to belong_to(:supplier).optional }
    it { is_expected.to belong_to(:section).optional }
    it { is_expected.to belong_to(:receivable_account).optional }
    it { is_expected.to belong_to(:service_revenue_account).optional }
    it { is_expected.to belong_to(:sales_discount_account).optional }
    it { is_expected.to have_many :accessories }
    it { is_expected.to belong_to(:customer).optional }
    it { is_expected.to belong_to :store_front }
    it { is_expected.to have_one :charge_invoice }
    it { is_expected.to have_many :technician_work_orders }
    it { is_expected.to have_many :technicians }
    it { is_expected.to have_many :work_order_updates }
    it { is_expected.to have_many :work_order_service_charges }
    it { is_expected.to have_many :service_charges }
    it { is_expected.to have_many :sales_order_line_items }
    it { is_expected.to have_many :accessories }
    it { is_expected.to have_many :entries }
  end
  describe 'enums' do
  end

  it ".done_and_rto" do
    received_work_order = create(:work_order, status: 'received')
    done_work_order     = create(:work_order, status: 'done')
    rto_work_order      = create(:work_order, status: 'return_to_owner')

    expect(described_class.done_and_rto).to include(done_work_order)
    expect(described_class.done_and_rto).to include(rto_work_order)
    expect(described_class.done_and_rto).to_not include(received_work_order)
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :physical_condition }
    it { is_expected.to validate_presence_of :reported_problem }
    it { is_expected.to validate_presence_of :customer_id }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:description).to(:product_unit) }
    it { is_expected.to delegate_method(:model_number).to(:product_unit) }
    it { is_expected.to delegate_method(:serial_number).to(:product_unit) }
    it { is_expected.to delegate_method(:full_name).to(:customer).with_prefix }
    it { is_expected.to delegate_method(:contact_number).to(:customer).with_prefix }
    it { is_expected.to delegate_method(:address).to(:customer).with_prefix }
    it { is_expected.to delegate_method(:avatar).to(:customer) }
    it { is_expected.to delegate_method(:number).to(:charge_invoice).with_prefix }

  end

  it '#default_receivable_account' do
    receivable_account = create(:asset)
    work_order         = create(:work_order, receivable_account: nil)
    work_order_2       = create(:work_order, receivable_account: receivable_account)

    expect(work_order.default_receivable_account).to eql work_order.store_front.receivable_account
    expect(work_order_2.default_receivable_account).to eql receivable_account
  end

  it '#default_sales_discount_account' do
    discount_account = create(:revenue)
    work_order         = create(:work_order, sales_discount_account: nil)
    work_order_2       = create(:work_order, sales_discount_account: discount_account)

    expect(work_order.default_sales_discount_account).to eql work_order.store_front.sales_discount_account
    expect(work_order_2.default_sales_discount_account).to eql discount_account
  end

  it '#default_service_revenue_account' do
    service_revenue_account = create(:revenue)
    work_order              = create(:work_order, service_revenue_account: nil)
    work_order_2            = create(:work_order, service_revenue_account: service_revenue_account)

    expect(work_order.default_service_revenue_account).to eql work_order.store_front.service_revenue_account
    expect(work_order_2.default_service_revenue_account).to eql service_revenue_account
  end



end
