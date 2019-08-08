require 'rails_helper'

describe TechnicianWorkOrder, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :technician }
    it { is_expected.to belong_to :work_order }
  end
end
