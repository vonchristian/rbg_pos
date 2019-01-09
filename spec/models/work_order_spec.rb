require 'rails_helper'

describe WorkOrder do
  describe 'associations' do
    it { is_expected.to belong_to :product_unit }
    it { is_expected.to belong_to(:supplier).optional }
    it { is_expected.to belong_to :section }
    it { is_expected.to have_many :accessories }
    it { is_expected.to belong_to(:customer).optional }
    it { is_expected.to belong_to :store_front }
    it { is_expected.to have_one :charge_invoice }
    it { is_expected.to have_many :technician_work_orders }
  end
end
