require 'rails_helper'

describe Department, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :customer }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:customer_id) }
  end

  it "#customer_name_and_department" do
    customer   = create(:customer)
    department = create(:department, customer: customer)
    expect(department.customer_name_and_department).to eql("#{customer.name} - #{department.name}")
  end
end
