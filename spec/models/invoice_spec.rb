require 'rails_helper'

describe Invoice, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :invoiceable }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :number }
  end
  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:invoiceable).with_prefix }
    it { is_expected.to delegate_method(:customer_full_name).to(:invoiceable) }
  end 
end
