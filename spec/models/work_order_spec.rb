require 'rails_helper'

describe WorkOrder do
  describe 'associations' do
    it { is_expected.to belong_to :product_unit }
    it { is_expected.to belong_to(:supplier).optional }
    it { is_expected.to belong_to(:section).optional }
    it { is_expected.to belong_to(:receivable_account) }
    it { is_expected.to belong_to(:service_revenue_account) }
    it { is_expected.to belong_to(:sales_discount_account) }
    it { is_expected.to belong_to(:sales_revenue_account) }
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to have_many :accessories }
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
  describe 'validations' do
    it { is_expected.to validate_presence_of :physical_condition }
    it { is_expected.to validate_presence_of :reported_problem }
    it { is_expected.to validate_presence_of :customer_id }
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

  it '.received_at(args = {})' do 
    old    = create(:work_order, date_received: Date.current.last_month)
    recent = create(:work_order, date_received: Date.current)

    expect(described_class.received_at(from_date: Date.current.last_month.beginning_of_month, to_date: Date.current.last_month.end_of_month)).to include(old)
    expect(described_class.received_at(from_date: Date.current.last_month.beginning_of_month, to_date: Date.current.last_month.end_of_month)).to_not include(recent)
    expect(described_class.received_at(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to include(recent)
    expect(described_class.received_at(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to_not include(old)
  end

  it '.released_at(args = {})' do 
    old    = create(:work_order, release_date: Date.current.last_month)
    recent = create(:work_order, release_date: Date.current)

    expect(described_class.released_on(from_date: Date.current.last_month.beginning_of_month, to_date: Date.current.last_month.end_of_month)).to include(old)
    expect(described_class.released_on(from_date: Date.current.last_month.beginning_of_month, to_date: Date.current.last_month.end_of_month)).to_not include(recent)
    expect(described_class.released_on(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to include(recent)
    expect(described_class.released_on(from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month)).to_not include(old)
  end

end
